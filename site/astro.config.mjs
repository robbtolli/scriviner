import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  site: 'https://scrivener.tollitech.com',
  integrations: [
    starlight({
      title: 'Scrivener',
      description: 'Modern TTRPG Character Manager & Rules Engine',
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/robb/scrivener' },
      ],
      customCss: ['./src/styles/custom.css'],
      sidebar: [
        {
          label: 'Quick Links',
          items: [
            { label: '← Back to Website', link: '/' },
            { label: '🚀 Live Web Demo', link: '/demo/' },
            { label: '📥 Download App', link: '/download/' },
            { label: '🎲 Dice Caster', link: '/dice/' },
          ],
        },
        {
          label: 'Documentation Hub',
          slug: '',
        },
        {
          label: 'User Guides',
          items: [
            { label: 'Getting Started', slug: 'user-guide/getting-started' },
            { label: 'Character Sheet Mastery', slug: 'user-guide/character-sheet' },
            { label: 'Dice Roller Reference', slug: 'user-guide/dice-roller' },
            { label: 'Export, Backup & PDF', slug: 'user-guide/export-and-backup' },
          ],
        },
        {
          label: 'Custom Themes',
          items: [
            { label: 'Theme Architecture', slug: 'themes/theme-architecture' },
            { label: 'Built-in Themes', slug: 'themes/builtin-themes' },
            { label: 'Authoring Custom Themes', slug: 'themes/authoring-custom-themes' },
            { label: 'Per-Character Theming', slug: 'themes/per-character-theming' },
          ],
        },
        {
          label: 'Plugin Development',
          items: [
            { label: 'Plugin Architecture', slug: 'plugins/plugin-architecture' },
            { label: 'Manifest Specification', slug: 'plugins/manifest-spec' },
            { label: 'Authoring Compendiums', slug: 'plugins/authoring-compendiums' },
            { label: 'Authoring Rulesets', slug: 'plugins/authoring-systems' },
            { label: 'Packaging & Distribution', slug: 'plugins/packaging-and-distribution' },
          ],
        },
        {
          label: 'Legal & Privacy',
          items: [
            { label: 'Privacy Policy', slug: 'privacy-policy' },
          ],
        },
      ],
    }),
  ],
});
