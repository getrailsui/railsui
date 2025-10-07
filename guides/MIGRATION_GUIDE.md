# Rails UI Migration Guide

Covers migrating existing installations and common upgrade scenarios.

## Table of Contents

- [Migrating from cssbundling-rails to tailwindcss-rails](#migrating-from-cssbundling-rails-to-tailwindcss-rails)
- [Upgrading from v3.2 and Earlier](#upgrading-from-v32-and-earlier)
- [Switching Between Build Modes](#switching-between-build-modes)
- [Troubleshooting](#troubleshooting)

---

## Migrating from cssbundling-rails to tailwindcss-rails

Rails UI v3.3+ uses `tailwindcss-rails` to support #nobuild, faster builds, and requires fewer dependencies.

### Automatic Migration (easy mode)

If you app previously used `cssbundling-rails`, you can migrate to `tailwindcss-rails` with the following command:

```bash
rails railsui:migrate_to_tailwindcss_rails
```

This will:
- Install tailwindcss-rails gem
- Remove Tailwind packages from package.json
- Update your Procfile.dev
- Create new CSS file at `app/assets/tailwind/application.css`
- **Preserve your old CSS file** for manual migration

**Important**: Your existing `app/assets/stylesheets/application.tailwind.css` is preserved. Manually copy any custom CSS, `@import` statements, or legacy styles to `app/assets/tailwind/application.css`.

### Migrating Custom CSS

Copy your customizations from the old file to the new one:

```css
/* Old: app/assets/stylesheets/application.tailwind.css Tailwind v3 */
@tailwind base;
@tailwind components;
@tailwind utilities;

@import "custom/buttons";
.my-custom-component { /* ... */ }
```

```css
/* New: app/assets/tailwind/application.css */
@import "tailwindcss";

@import "custom/buttons";
.my-custom-component { /* ... */ }
```

The `@import "tailwindcss";` directive replaces the three separate `@tailwind` directives (Tailwind v4 syntax).

---

## Upgrading from v3.2 and Earlier

### Quick Upgrade

```bash
bundle update railsui
rails railsui:migrate_to_tailwindcss_rails
rails generate railsui:update
bin/dev
```

### What Changed

- **CSS**: Now uses `tailwindcss-rails` instead of `cssbundling-rails`
- **Default mode**: No-build (importmap), like Rails 8
- **Installation**: Use `--build` flag to opt into build mode for JS bundling.

### New installation workflow

```bash
# nobuild mode (default)
rails new myapp
bundle add railsui
rails railsui:install

# build mode (with JS bundler)
rails new myapp -j [bun|esbuild|rollup|webpack]
bundle add railsui
rails railsui:install --build
```

The TL;DR;: No need to use `-c tailwind` anymore - Rails UI handles CSS via the tailwindcss-rails gem.

---

## Switching between build modes

You can switch between nobuild (importmaps) and build (JS bundler) modes anytime though we'd suggest picking one path and sticking to it for less complexity.

### Switch to nobuild mode

```bash
# 1. Install importmap-rails if needed
bundle add importmap-rails
rails importmap:install

# 2. Update config/railsui.yml
# Change: build_mode: nobuild

# 3. Regenerate Rails UI assets
rails generate railsui:update

# 4. Update Procfile.dev (remove js line):
# web: bin/rails server
# css: bin/rails tailwindcss:watch

# 5. Restart server
bin/dev
```

### Switch to build mode

```bash
# 1. Install jsbundling-rails and a bundler
bundle add jsbundling-rails
rails javascript:install:[bun|esbuild|rollup|webpack]

# 2. Update config/railsui.yml
# Change: build_mode: build

# 3. Regenerate Rails UI assets
rails generate railsui:update

# 4. Install JS dependencies
yarn install

# 5. Update Procfile.dev (add js line):
# web: bin/rails server
# css: bin/rails tailwindcss:watch
# js: yarn build:js --watch

# 6. Restart server
bin/dev
```

## Troubleshooting

### CSS not compiling

```bash
rails tailwindcss:build
rails tmp:clear
bin/dev
```

Check that `Procfile.dev` includes `css: bin/rails tailwindcss:watch`.

### JavaScript not loading (no-build mode)

Check `config/importmap.rb` for required pins:
```bash
cat config/importmap.rb
```

Should include: `@hotwired/stimulus`, `railsui-stimulus`, `stimulus-use`, `tippy.js`, and theme dependencies.

If missing:
```bash
bundle add importmap-rails
rails importmap:install
```

### JavaScript not loading (build mode)

Ensure JS bundler is running in `Procfile.dev`:
```
js: yarn build:js --watch
```

Install dependencies:
```bash
yarn install
yarn build:js
```

### Conflicting Tailwind versions

Remove Tailwind from package.json:
```bash
yarn remove tailwindcss @tailwindcss/cli @tailwindcss/typography
rails tailwindcss:build
```

Verify only the gem is installed:
```bash
ls node_modules | grep tailwind  # Should be empty
bundle list | grep tailwindcss   # Should show tailwindcss-rails
```

### Getting Help

- Documentation: https://railsui.com/docs
- Issues: https://github.com/getrailsui/railsui/issues
- Discussions: https://github.com/getrailsui/railsui/discussions

---

## Quick Reference

```bash
# Migration
rails railsui:migrate_to_tailwindcss_rails

# Rebuild assets
rails tailwindcss:build
yarn build:js  # (build mode only)

# Update Rails UI (regenerates assets for current build mode)
rails generate railsui:update
```
