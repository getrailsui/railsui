# Configuration guide

This guide covers configuring Rails UI for your application, including build modes, themes, and customization options.

## Table of Contents

- [Configuration file](#configuration-file)
- [Build mode configuration](#build-mode-configuration)
- [Color and theme customization](#color-and-theme-customization)

---

## Configuration file

Rails UI stores its configuration in:

```
config/railsui.yml
```

This file is automatically created during installation and can be edited manually or via the admin UI at `/railsui`.

---

## Build mode configuration

Rails UI supports two JavaScript build modes. This setting determines how JavaScript is loaded and processed.

### Build mode options

#### Option 1: No-build mode (importmap) - default

Nobuild mode is the default for Rails UI v3.3+. Simply running the installer `rails railsui:install` after adding the `railsui_pro` gem to your app's Gemfile gets everything set up using importmaps.

**Best for**: Simple apps, prototypes, apps without complex JS requirements

```yaml
# config/railsui.yml
application_name: My App
support_email: support@example.com
theme: hound
build_mode: nobuild
pages:
  - dashboard
  - pricing
  - ...
```

**Characteristics:**
- ✅ Zero build step for JavaScript
- ✅ No Node.js required
- ✅ JavaScript loaded from CDN via importmap
- ✅ Fast refresh during development
- ✅ Simpler deployment
- ⚠️ Less control over JS bundling
- ⚠️ Requires internet for CDN dependencies (dev mode)

**Development server:**
```bash
bin/dev
# Runs: Rails server + Tailwind CSS watcher only
```

#### Option 2: Build Mode

**Best for**: Production apps, TypeScript projects, complex JS requirements

To install, run the installer with the `--build` flag:

`rails railsui:install --build`

If already installed you may modify your `railsui.yml` file.

```yaml
# config/railsui.yml
application_name: My App
support_email: support@example.com
theme: hound
build_mode: build
pages:
  - dashboard
  - pricing
  - ...
```

**Characteristics:**
- ✅ Full control over JavaScript bundling
- ✅ Supports TypeScript, JSX, advanced tooling
- ✅ Tree-shaking and optimization
- ✅ Works offline
- ⚠️ Requires Node.js and package manager
- ⚠️ Additional build step
- ⚠️ Slightly more complex deployment

**Development server:**
```bash
bin/dev
# Runs: Rails server + Tailwind CSS watcher + JS bundler watcher
```

**Supported JS bundlers:**
- Bun
- esbuild
- Rollup
- Webpack
---

## Color and theme customization

Most themes include primary and secondary color palettes in addition to Tailwind CSS v4 defaults. Colors are defined in CSS using Tailwind CSS v4.


**Step 1**: Edit `app/assets/stylesheets/railsui/theme.css`

**Step 2**: Update color or utility values based on Tailwind CSS:

For colors, we like using a tool like [Tailwind Color Generator](https://uicolors.app/create) to generate a complete color palette or [https://www.tints.dev/](https://www.tints.dev/) to generate oklch colors which have a wider gamut.

```css
@theme {
  /* Your brand colors */
  --color-primary-500: #3b82f6;
  --color-primary-600: #2563eb;
  /* ... update other shades ... */
}
```

**Step 3**: Rebuild CSS or reboot server:

```bash
rails tailwindcss:build
```

### Using Colors in Templates

Colors are available via Tailwind utility classes:

```html
<!-- Primary colors -->
<button class="bg-primary-600 hover:bg-primary-700 text-white">
  Click me
</button>

<!-- Secondary colors -->
<div class="border-secondary-200 bg-secondary-50">
  Content
</div>
```

### Validating Configuration

Rails UI validates configuration on save. Invalid config will raise errors:

**Valid values:**
- `application_name`: Non-empty string
- `support_email`: Valid email format
- `theme`: One of: `hound`, `shepherd`, `corgie`
- `build_mode`: One of: `build`, `nobuild`
- `pages`: Array of strings

**Example validation error:**
```
❌ Configuration validation failed:
  - Invalid theme: 'custom'. Available themes: hound, shepherd, corgie, ...
  - Invalid email format for support_email: 'not-an-email'
```

### Loading configuration programmatically

While you can do this, it's likely easier to visit `/railsui` locally to update these values in the form and click `Save Changes`. 

```ruby
# Load current configuration
config = Railsui::Configuration.load!

# Access values
puts config.theme          # => "hound"
puts config.build_mode     # => "nobuild"
puts config.nobuild?       # => true
puts config.build?         # => false

# Update configuration
config.theme = "shepherd"
config.save

# Update with hash
Railsui::Configuration.update(
  theme: "shepherd",
  application_name: "New Name"
)
```

---

## Getting Help

- **Documentation**: https://railsui.com/docs
- **Discussions**: https://github.com/getrailsui/railsui/discussions
- **Issues**: https://github.com/getrailsui/railsui/issues
