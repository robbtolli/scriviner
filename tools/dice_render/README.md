# Dice render pipeline

Generates the blank-faced 3D dice tumble sprite atlases in `assets/dice/`.

```bash
# All dice, 2 variants x 24 frames at 160 px (about 6 minutes on 16 cores)
blender -b -P tools/dice_render/render_dice.py -- --variants 2

# Only some dice (merges into the existing dice_manifest.json)
blender -b -P tools/dice_render/render_dice.py -- --only d20,d6

# Shrink the PNGs afterwards
for f in assets/dice/d*.png; do pngquant --force --quality 70-95 --ext .png "$f"; done
```

Options: `--out`, `--only`, `--frames`, `--variants`, `--size`.

- Tested with Blender 5.0.1 (Cycles, CPU).
- The script needs `numpy` inside Blender. If your Blender runs on a Python that
  cannot see the system numpy, the script appends `/usr/lib/python3/dist-packages`
  automatically.
- The last frame of each variant shows one face looking straight at the camera.
  `dice_manifest.json` stores that face's centre and size so the app can overlay
  the rolled number. The die is rendered in neutral grey and tinted at runtime.
