# Migration Guide: Rails UI to tailwindcss-rails

This guide explains the changes made to Rails UI to use `tailwindcss-rails` instead of the previous CSS bundling approach.

## What Changed

### Before (v3.1.5)
- Required `cssbundling-rails` and `jsbundling-rails`
- Needed `rails new app_name -c tailwind -j esbuild` for new apps
- Used `yarn build:css` for CSS compilation
- Required manual setup of Tailwind CSS

### After (v3.1.6+)
- Uses `tailwindcss-rails` as the primary CSS management solution
- Simplified installation: `rails new app_name -j esbuild`
- Automatic Tailwind CSS installation during Rails UI setup
- Uses `rails tailwindcss:build` and `rails tailwindcss:watch` for CSS management

## Installation Changes

### New Applications

**Before:**
```bash
rails new app_name -c tailwind -j esbuild
gem "railsui"
bundle install
rails railsui:install
```

**After:**
```bash
rails new app_name
gem "railsui"
bundle install
rails railsui:install
```

### Existing Applications

**Before:**
```bash
./bin/bundle add cssbundling-rails
./bin/rails css:install:tailwind
./bin/bundle add jsbundling-rails
./bin/rails javascript:install:esbuild
gem "railsui"
bundle install
rails railsui:install
```

**After:**
```bash
gem "railsui"
bundle install
rails railsui:install
```

## Development Workflow

### Before
```bash
bin/dev  # Uses Procfile.dev with cssbundling-rails
```

### After
```bash
bin/dev  # Uses Procfile.dev with tailwindcss-rails
```

The new Procfile.dev includes:
```
web: bin/rails server -p 3000
css: bin/rails tailwindcss:watch
js: yarn build --watch
```

## File Structure Changes

### CSS Files
- **Before:** `app/assets/stylesheets/application.tailwind.css`
- **After:** `app/assets/tailwind/application.css`

## Benefits

1. **Simplified Installation:** No need for `-c tailwind` flag anymore. Less package manager headaches.
2. **Better Integration:** Native Rails integration with `tailwindcss-rails`
3. **Reduced Dependencies:** Fewer gems to manage
4. **Improved Performance:** More efficient CSS compilation
5. **Better Development Experience:** Integrated watch mode with Rails server

## Migration Steps

If you're upgrading from a previous version:

1. Update your Gemfile:
   ```ruby
   gem "railsui"
   ```

2. Run bundle update:
   ```bash
   bundle update railsui
   ```

3. Reinstall Rails UI:
   ```bash
   rails railsui:install
   ```

4. Update your development workflow:
   - Use `bin/dev` for development
   - CSS changes are automatically watched
   - No manual CSS compilation needed

## Troubleshooting

### If you see CSS compilation errors:
1. Make sure `tailwindcss-rails` is installed. Rails UI should add it for you if not.
2. Run `rails tailwindcss:install` if needed (optional)
3. Check that `app/assets/tailwind/application.css` exists

### If you see JavaScript errors:
1. Make sure you have a JavaScript bundler installed
2. Run `rails javascript:install:esbuild` (or your preferred bundler)
3. Check that your `package.json` has the correct build scripts

### If the development server doesn't start:
1. Make sure `Procfile.dev` exists and is correct
2. Check that all dependencies are installed
3. Try running `bin/rails server` and `bin/rails tailwindcss:watch` separately

## Support

If you encounter any issues during migration, please:

1. Check the [Rails UI documentation](https://railsui.com/docs)
2. Review the [tailwindcss-rails documentation](https://github.com/rails/tailwindcss-rails)
3. Open an issue on the [Rails UI GitHub repository](https://github.com/getrailsui/railsui)
