"""Renders blank-faced polyhedral dice tumble animations for Scrivener.

Usage (headless):
    blender -b -P tools/dice_render/render_dice.py -- [--out assets/dice]
        [--only d6,d20] [--frames 24] [--variants 2] [--size 160]

For each die type this writes <out>/<die>.png (a sprite atlas of
variants x frames) and merges per-die metadata into <out>/dice_manifest.json.
The last frame of every variant shows the same face looking straight at the
camera (face centre and size are stored in the manifest) so the app can overlay
the rolled number on it. Tint is applied at runtime, so the die is rendered in
a neutral light-grey material.
"""

import json
import math
import os
import random
import sys

import bmesh
import bpy
import mathutils
from bpy_extras.object_utils import world_to_camera_view

# Some distro Blender builds run on a different Python than the system one and
# cannot see apt's numpy. Fall back to the system dist-packages if needed.
try:
    import numpy  # noqa: F401
except ModuleNotFoundError:
    sys.path.append('/usr/lib/python3/dist-packages')

PHI = (1 + 5 ** 0.5) / 2
SUPERSAMPLE = 2
COLUMNS = 8


def parse_args():
    argv = sys.argv[sys.argv.index('--') + 1:] if '--' in sys.argv else []
    opts = {'out': 'assets/dice', 'only': None, 'frames': 24, 'variants': 2, 'size': 160}
    i = 0
    while i < len(argv):
        key = argv[i].lstrip('-')
        val = argv[i + 1]
        opts[key] = val if key in ('out', 'only') else int(val)
        i += 2
    if opts['only']:
        opts['only'] = opts['only'].split(',')
    return opts


# --------------------------------------------------------------------------
# Geometry
# --------------------------------------------------------------------------

def polyhedron_points(sides):
    V = mathutils.Vector
    if sides == 4:
        return [V(p) for p in [(1, 1, 1), (1, -1, -1), (-1, 1, -1), (-1, -1, 1)]]
    if sides == 6:
        return [V((x, y, z)) for x in (-1, 1) for y in (-1, 1) for z in (-1, 1)]
    if sides == 8:
        pts = []
        for s in (-1, 1):
            pts += [V((s, 0, 0)), V((0, s, 0)), V((0, 0, s))]
        return pts
    if sides == 10:
        c = math.cos(math.radians(36))
        z0 = (1 - c) / (1 + c)  # makes the kite faces planar
        pts = [V((0, 0, 1)), V((0, 0, -1))]
        for k in range(5):
            a = math.radians(72 * k)
            pts.append(V((math.cos(a), math.sin(a), z0)))
            b = math.radians(72 * k + 36)
            pts.append(V((math.cos(b), math.sin(b), -z0)))
        return pts
    if sides == 12:
        pts = [V((x, y, z)) for x in (-1, 1) for y in (-1, 1) for z in (-1, 1)]
        i = 1 / PHI
        for a in (-1, 1):
            for b in (-1, 1):
                pts += [V((0, a * i, b * PHI)), V((a * i, b * PHI, 0)), V((b * PHI, 0, a * i))]
        return pts
    if sides == 20:
        pts = []
        for a in (-1, 1):
            for b in (-1, 1):
                pts += [V((0, a, b * PHI)), V((a, b * PHI, 0)), V((b * PHI, 0, a))]
        return pts
    raise ValueError(sides)


def build_die(sides):
    pts = polyhedron_points(sides)
    radius = max(p.length for p in pts)
    bm = bmesh.new()
    for p in pts:
        bm.verts.new(p / radius)
    bmesh.ops.convex_hull(bm, input=bm.verts[:])
    bmesh.ops.dissolve_limit(bm, angle_limit=math.radians(1), verts=bm.verts[:], edges=bm.edges[:])
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces[:])
    mesh = bpy.data.meshes.new(f'd{sides}')
    bm.to_mesh(mesh)
    bm.free()
    obj = bpy.data.objects.new(f'd{sides}', mesh)
    bpy.context.scene.collection.objects.link(obj)
    for poly in mesh.polygons:
        poly.use_smooth = False
    bevel = obj.modifiers.new('bevel', 'BEVEL')
    bevel.width = 0.035
    bevel.segments = 2
    bevel.limit_method = 'ANGLE'
    mat = bpy.data.materials.new('die')
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes['Principled BSDF']
    bsdf.inputs['Base Color'].default_value = (0.72, 0.72, 0.72, 1)
    bsdf.inputs['Roughness'].default_value = 0.42
    mesh.materials.append(mat)
    return obj


def landing_rotation(obj, sides):
    """Quaternion that puts the chosen face toward the camera (+Z), upright."""
    mesh = obj.data
    face = max(mesh.polygons, key=lambda p: (p.area, -p.index))
    verts = [mesh.vertices[i].co.copy() for i in face.vertices]
    center = face.center.copy()
    q1 = face.normal.rotation_difference(mathutils.Vector((0, 0, 1)))
    rot_center = q1 @ center
    rot_verts = [q1 @ v for v in verts]
    if sides == 6:  # edge up (square face)
        a, b = rot_verts[0], rot_verts[1]
        up = ((a + b) / 2 - rot_center)
    elif sides == 10:  # kite: polar apex up
        apex = min(verts, key=lambda v: v.xy.length)
        up = q1 @ apex - rot_center
    else:  # vertex up
        up = max(rot_verts, key=lambda v: (v - rot_center).length) - rot_center
    angle = math.atan2(up.y, up.x)
    q2 = mathutils.Quaternion((0, 0, 1), math.pi / 2 - angle)
    return q2 @ q1, face.index


# --------------------------------------------------------------------------
# Scene
# --------------------------------------------------------------------------

def setup_scene(px):
    for o in list(bpy.data.objects):
        bpy.data.objects.remove(o)
    scene = bpy.context.scene
    scene.render.engine = 'CYCLES'
    scene.cycles.device = 'CPU'
    scene.cycles.samples = 48
    scene.cycles.use_denoising = False
    scene.render.film_transparent = True
    scene.render.resolution_x = scene.render.resolution_y = px * SUPERSAMPLE
    scene.render.resolution_percentage = 100
    scene.render.image_settings.file_format = 'PNG'
    scene.render.image_settings.color_mode = 'RGBA'
    scene.render.image_settings.color_depth = '8'
    scene.view_settings.view_transform = 'Standard'

    world = bpy.data.worlds.new('w')
    world.use_nodes = True
    bg = world.node_tree.nodes['Background']
    bg.inputs['Color'].default_value = (0.9, 0.9, 0.95, 1)
    bg.inputs['Strength'].default_value = 0.8
    scene.world = world

    cam_data = bpy.data.cameras.new('cam')
    cam_data.angle = math.radians(20)
    cam = bpy.data.objects.new('cam', cam_data)
    cam.location = (0, 0, 10)
    cam.rotation_euler = (0, 0, 0)
    scene.collection.objects.link(cam)
    scene.camera = cam

    sun_data = bpy.data.lights.new('sun', 'SUN')
    sun_data.energy = 2.0
    sun_data.angle = math.radians(18)
    sun = bpy.data.objects.new('sun', sun_data)
    sun.rotation_euler = (math.radians(22), math.radians(-12), math.radians(25))
    scene.collection.objects.link(sun)
    return scene, cam


def ground_plane(z):
    mesh = bpy.data.meshes.new('ground')
    mesh.from_pydata([(-6, -6, 0), (6, -6, 0), (6, 6, 0), (-6, 6, 0)], [], [(0, 1, 2, 3)])
    obj = bpy.data.objects.new('ground', mesh)
    obj.location.z = z
    obj.is_shadow_catcher = True
    bpy.context.scene.collection.objects.link(obj)
    return obj


def render_frame(scene, path):
    scene.render.filepath = path
    bpy.ops.render.render(write_still=True)


def load_pixels(path, px):
    import numpy as np
    img = bpy.data.images.load(path)
    img.colorspace_settings.name = 'Non-Color'
    img.alpha_mode = 'STRAIGHT'
    n = img.size[0]
    arr = np.array(img.pixels[:], dtype=np.float32).reshape(n, n, 4)
    bpy.data.images.remove(img)
    rgb = arr[..., :3] * arr[..., 3:4]  # premultiply before averaging
    pre = np.concatenate([rgb, arr[..., 3:4]], axis=-1)
    s = SUPERSAMPLE
    pre = pre.reshape(px, s, px, s, 4).mean(axis=(1, 3))
    a = pre[..., 3:4]
    out = np.where(a > 1e-4, pre[..., :3] / np.maximum(a, 1e-4), 0)
    return np.concatenate([out, a], axis=-1)  # bottom-up rows (Blender order)


def project(scene, cam, co):
    p = world_to_camera_view(scene, cam, co)
    return (p.x, 1 - p.y)


# --------------------------------------------------------------------------
# Main
# --------------------------------------------------------------------------

def ease_out(t, power=2.0):
    return 1 - (1 - t) ** power


def render_die(sides, opts, tmpdir):
    import numpy as np
    px, frames, variants = opts['size'], opts['frames'], opts['variants']
    scene, cam = setup_scene(px)
    obj = build_die(sides)
    obj.rotation_mode = 'QUATERNION'
    q_final, face_index = landing_rotation(obj, sides)

    # Resting height: lowest vertex of the landed die sits on the ground plane.
    mw = q_final.to_matrix()
    min_z = min((mw @ v.co).z for v in obj.data.vertices)
    ground_plane(min_z)

    cols = COLUMNS
    total = frames * variants
    rows = math.ceil(total / cols)
    atlas = np.zeros((rows * px, cols * px, 4), dtype=np.float32)
    meta = {}

    rng = random.Random(sides * 101)
    for v in range(variants):
        axis1 = mathutils.Vector((rng.uniform(-1, 1), rng.uniform(-1, 1), rng.uniform(-0.4, 0.4))).normalized()
        axis2 = mathutils.Vector((rng.uniform(-1, 1), rng.uniform(-0.3, 0.3), rng.uniform(-1, 1))).normalized()
        turns1 = rng.uniform(2.0, 3.0) * 2 * math.pi
        turns2 = rng.uniform(1.0, 2.0) * 2 * math.pi
        for f in range(frames):
            t = f / (frames - 1)
            r = (1 - t) ** 2
            q = (mathutils.Quaternion(axis1, turns1 * r)
                 @ mathutils.Quaternion(axis2, turns2 * r) @ q_final)
            obj.rotation_quaternion = q
            lift = 2.6 * (1 - t) ** 1.5 * abs(math.cos(2.5 * math.pi * t))
            obj.location = (0.0, 0.0, lift)
            path = os.path.join(tmpdir, f'{sides}_{v}_{f}.png')
            render_frame(scene, path)
            tile = load_pixels(path, px)
            idx = v * frames + f
            r0, c0 = divmod(idx, cols)
            # Atlas is stored bottom-up here; flip rows so the saved PNG is top-down.
            y0 = (rows - 1 - r0) * px
            atlas[y0:y0 + px, c0 * px:(c0 + 1) * px] = tile
            os.remove(path)
            print(f'd{sides} variant {v} frame {f + 1}/{frames}', flush=True)

    # Final-pose face geometry in normalised image coords (top-left origin).
    obj.rotation_quaternion = q_final
    obj.location = (0, 0, 0)
    bpy.context.view_layer.update()
    face = obj.data.polygons[face_index]
    pts = [project(scene, cam, obj.matrix_world @ obj.data.vertices[i].co) for i in face.vertices]
    center = project(scene, cam, obj.matrix_world @ face.center)
    n = len(pts)
    inscribed = min(
        math.dist(center, ((pts[i][0] + pts[(i + 1) % n][0]) / 2, (pts[i][1] + pts[(i + 1) % n][1]) / 2))
        for i in range(n)
    )
    meta = {
        'sides': sides,
        'atlas': f'd{sides}.png',
        'columns': cols,
        'rows': rows,
        'frameSize': px,
        'frames': frames,
        'variants': variants,
        'faceCenter': [round(center[0], 4), round(center[1], 4)],
        'faceRadius': round(inscribed, 4),
    }

    img = bpy.data.images.new(f'atlas{sides}', cols * px, rows * px, alpha=True)
    img.colorspace_settings.name = 'Non-Color'
    img.alpha_mode = 'STRAIGHT'
    img.pixels.foreach_set(atlas.ravel())
    img.file_format = 'PNG'
    out_path = os.path.join(opts['out'], f'd{sides}.png')
    img.filepath_raw = out_path
    img.save()
    return meta


def main():
    opts = parse_args()
    os.makedirs(opts['out'], exist_ok=True)
    manifest_path = os.path.join(opts['out'], 'dice_manifest.json')
    manifest = {}
    if os.path.exists(manifest_path):
        with open(manifest_path) as fh:
            manifest = json.load(fh)
    tmpdir = os.path.join(opts['out'], '_tmp')
    os.makedirs(tmpdir, exist_ok=True)
    for sides in (4, 6, 8, 10, 12, 20):
        name = f'd{sides}'
        if opts['only'] and name not in opts['only']:
            continue
        manifest[name] = render_die(sides, opts, tmpdir)
    os.rmdir(tmpdir)
    with open(manifest_path, 'w') as fh:
        json.dump(manifest, fh, indent=2, sort_keys=True)
    print('done')


main()
