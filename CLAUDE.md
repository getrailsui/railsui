# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Rails UI is a Ruby on Rails engine that provides professionally designed themes and components for Rails applications. It leverages Tailwind CSS and Stimulus.js to deliver breath-taking UI components and pre-built pages to fast-track Rails development.

## Architecture

### Rails Engine Structure
- **Engine**: `lib/railsui/engine.rb` - Main Rails engine with asset precompilation and helper initialization
- **Configuration**: `lib/railsui/configuration.rb` - Handles theme configuration and settings
- **Theme System**: `lib/railsui/themes.rb` and `lib/railsui/theme_helper.rb` - Dynamic theme switching and management
- **Components**: View helpers in `app/helpers/railsui/` for reusable UI components

### Key Directories
- `app/views/railsui/` - Engine views including themes, components, and system documentation
- `app/controllers/railsui/` - Engine controllers for admin interface, configuration, and component demos
- `app/javascript/` - Stimulus controllers and Rails UI JavaScript library
- `lib/generators/railsui/` - Rails generators for installation, scaffolding, and updates
- `config/` - Theme configuration files (colors.yml, pages.yml, theme.yml)

### Component System
Components are organized by category:
- **UI Components**: accordion, alert, avatar, badge, breadcrumb, button, card, dropdown, modal, navigation, pagination, tabs, toast, tooltip
- **Form Components**: input, checkbox, radio, select, switch, validation, input groups
- **Content Components**: typography, tables, images
- **Layout Components**: authentication templates, mailers

## Development Commands

### JavaScript Build
```bash
npm run build:js  # Builds JavaScript assets using esbuild
```

### Ruby Testing & Linting
```bash
rake test      # Run minitest suite
rake standard  # Run StandardRB linting
rake           # Run both tests and linting (default task)
```

### Rails UI Installation (for testing)
```bash
rails railsui:install    # Install Rails UI in a host application
rails generate railsui:scaffold MODEL_NAME  # Generate scaffolded views with Rails UI styling
```

## Theme System

Rails UI uses a dynamic theme system where themes are swappable at runtime:

- **Theme Configuration**: Stored in `config/theme.yml` and managed via the admin interface
- **Theme Assets**: Each theme includes custom CSS, JavaScript, and asset files
- **Color System**: Built on Tailwind CSS with custom `primary` and `secondary` colors defined per theme
- **Pages**: Themes include pre-built page templates in `app/views/rui/` (read-only, copied to host apps)

## JavaScript Architecture

- **Framework**: Stimulus.js controllers for interactive components
- **Build System**: esbuild for bundling JavaScript assets
- **Dependencies**: Includes Stimulus controllers, highlight.js, flatpickr, tippy.js, and vanilla-colorful
- **Custom Library**: `railsui-stimulus` package provides shared Stimulus behaviors

## Asset Pipeline

- **CSS**: Tailwind CSS with theme-specific customizations
- **JavaScript**: Built with esbuild and served from `app/assets/builds/railsui/`
- **Images**: Theme-specific assets and icon collections (primarily Heroicons via railsui_icon gem)

## Testing Approach

- **Framework**: Minitest for unit testing
- **Files**: Tests located in `test/` directory following `test_*.rb` naming convention
- **Coverage**: Focus on engine functionality, configuration, and theme system

## Configuration Management

Rails UI uses YAML configuration files:
- `config/colors.yml` - Theme color definitions
- `config/pages.yml` - Available page templates per theme  
- `config/theme.yml` - Active theme settings

Configuration is managed through the admin interface at `/railsui` and persisted to these files.

## Component Development

When creating new components:
1. Add view templates to appropriate `app/views/railsui/systems/` subdirectory
2. Create corresponding Stimulus controllers in `app/javascript/controllers/`
3. Add route definitions in `config/routes.rb`
4. Update component documentation views
5. Follow existing patterns for responsive design and accessibility

## Integration Notes

- Requires Rails 7.0+ and Ruby 2.7+
- Designed to work with cssbundling-rails and jsbundling-rails
- Uses meta-tags gem for SEO functionality
- Integrates with railsui_icon gem for icon management