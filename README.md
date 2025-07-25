![Rails UI Docs](https://f001.backblazeb2.com/file/railsui/docs/rui-docs-header.png)

# Rails UI

Professionally designed themes and components for Ruby on Rails. Leverage breath-taking UI to fast-track your next idea.

### Links

- [Website](https://railsui.com)
- [Documentation](https://railsui.com/docs)
- [FAQs](https://railsui.com/docs/faqs)
- [Discussions](https://github.com/getrailsui/railsui/discussions)
- [Updates](https://railsui.com/updates)
- [Follow on X](https://x.com/railsui_)
- [Migrating from v2](https://railsui.com/docs/updates)

## Installation

You must already have node and yarn installed on your system. You will also need npx version 7.1.0 or later. A solid understanding of Tailwind CSS will go far.

### New applications

The easiest install is on new Rails apps. Rails UI now uses `tailwindcss-rails` for CSS management, which is automatically installed when you run the Rails UI installer.

```bash
rails new app_name -j esbuild
```

### Existing applications

Rails UI now uses `tailwindcss-rails` for CSS management, which provides a simpler and more integrated approach to Tailwind CSS in Rails applications.

If you're migrating from an existing setup, Rails UI will automatically install `tailwindcss-rails` during the installation process.

#### JavaScript

Rails UI works best with JavaScript bundling. You can use any of the supported bundling solutions:

```bash
# For esbuild (recommended)
./bin/rails javascript:install:esbuild

# For webpack
./bin/rails javascript:install:webpack

# For rollup
./bin/rails javascript:install:rollup

# For bun
./bin/rails javascript:install:bun
```

Most of the JavaScript used in Rails UI is based on Stimulus.js and will work with any of these bundling solutions.

## Installation

Add the `railsui` gem to your Gemfile.

```ruby
# Gemfile
gem "railsui"
```

Run the bundle install command to fetch the new gem and its assets.

```bash
bundle install
```

The gem includes several tasks and generators. Run the `install` task to kick things off.

This task is responsible for setting the foundation for Rails UI, which includes assets, themes, theme-driven pages, and more. It will automatically install `tailwindcss-rails` if it's not already present.

The default theme for Rails UI is [Hound](https://railsui.com/themes/hound). It will install when you install Rails UI. You can change it any time.

```bash
rails railsui:install
```

After installing Rails UI, run your server using the `bin/dev` command and proceed to the configuration screen to customize your install (i.e. `localhost:3000/railsui` for new apps).

## Configuration

Configuration is a simple process where you configure your app's details (app name, support email), and theme.

Each theme comes with different pages and are designed for different niches in mind. They reside in the `app/views/rui` directory once installed and should be treated as read-only.

**Updating your configuration at anytime will overwrite the pages and theme assets so if you want to keep your changes, you'll need to copy the files to your application in another directory.**

## Themes

Themes are the core of Rails UI, combining UI components, pages, assets, JavaScript, and color palettes to help you create a professionally designed, niche application. The UI can adapt based on how you implement it.

Themes serve as a starting point for your app, with reusable components extracted for flexibility. These components are ready for use inside your application when you install Rails UI.

### Pages

A page is a professionaly designed starting point. They are completely optional to use and can save a lot of time if your app uses similar layouts and patterns.

Pages are located in the `app/views/rui` directory and are considered read-only. If you want to keep your changes after modifying your Rails UI configuration and saving changes, you'll need to copy the files to your application in another view directory.

More pages will be added over time.

### Included assets

Each theme comes with a collection of assets to help you get started. Much of these are placeholders and are not meant to be used in production. We strive to still create realistic examples for you to use as a starting point.

### UI components

After installing Rails UI and choosing a theme you'll find a collection of components and best practices for real-world applications at your disposal.

### Color

Each theme comes with a custom color palette built on top of the default Tailwind CSS v4 color palette. We've added two new colors for you to use in your app using Tailwind CSS classes called `primary` and `secondary`. You can change those colors any time in `app/assets/stylesheets/railsui/theme.css` (which gets imported into `app/assets/tailwind/application.css`).

### Icons

Bundled with Rails UI is a gem called [railsui_icon](https://github.com/getrailsui/railsui_icon). This gem includes a collection of icons that are used in all themes. Right now it's based soley on [heroicons](https://heroicons.com) and will be expanded to include more icons in the future.

### JavaScript

All Rails UI components are built on top of Stimulus.js. A theme includes custom Stimulus controllers and our own JavaScript library called [railsui-stimulus](https://github.com/getrailsui/railsui-stimulus) which is just an extraction of components we find ourselves using in our own apps and between themes.

## Updates

Run `bundle update railsui` from within your project and it should fetch the most recent version of the gem/engine directly from GitHub.

### Legacy v2

Version 2 of Rails UI has since been sunset. Unfortunately, there is no upgrade path we can share.

Version 3 was a rewrite of the gem and how Rails UI works to enable better flexibility. Version 3 offers the ability to swap themes, install on new and existing rails apps, and countless other smaller features. We chose this direction to enable more efficient development in the future and allow folks with existing apps the ability to use Rails UI.

You can find version 2 on a dedicated branch on the Github repo. If you're an active user of this version be sure to update your Gemfile with the appropriate branch.

```ruby
gem "railsui", github: "getrailsui/railsui", branch: "v2"
```

### v3+

Version 3 resides on the main branch accessbile via the main branch and/or rubygems.org.

```ruby
gem "railsui"
```

## Frequently Asked Questions

[Read FAQs here](https://railsui.com/docs/faqs).
