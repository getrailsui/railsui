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

The easiest install is on new Rails apps with options passed like so. For new apps, use the `-c tailwind` flag to install it.

```bash
rails new app_name -c tailwind -j esbuild
```

It's recommended to use the `-j` flag to one of the bundling solutions from the [`jsbundling-rails`](https://github.com/rails/jsbundling-rails) gem (bun, esbuild rollup, webpack) for max compatibility.

Support for [importmaps](https://github.com/rails/importmap-rails) or [propshaft](https://github.com/rails/propshaft) is untested at this time.

### Existing applications

#### CSS

For an existing app you need to first install Tailwind if you haven't. If you are using another CSS framework, like Bootstrap, remove that first for best results.

```bash
./bin/bundle add cssbundling-rails
./bin/rails css:install:tailwind
```

Note: There are several ways to approach adding Tailwind CSS support. We find the easiest way is using [cssbundling-rails](https://github.com/rails/cssbundling-rails) gem for max control. If you were to scaffold a new rails application, this gem is the one used when passing `-c` or `-css`.

Adding Tailwind CSS to an existing app _may_ result in CSS class name conflicts. We've done our best to make it integrate with your existing setup but there's always a chance.

#### JavaScript

Rails UI works best combined with the [jsbundling-rails](https://github.com/rails/jsbundling-rails) gem.

When ready, install jsbundling-rails using the gem and the installer task. Choose the build tool you prefer.

```bash
./bin/bundle add jsbundling-rails
./bin/rails javascript:install:[bun|esbuild|rollup|webpack]
```

Most of the JavaScript used in Rails UI is based on Stimulus.js. This code can likely work fine alongside something like importmaps or propshaft but we have not tested this theory just yet.

## Installation

Add the `railsui` gem to your Gemfile.

```ruby
# Gemfile
gem "railsui", github: "getrailsui/railsui", branch: "main"
```

Run the bundle install command to fetch the new gem and its assets.

```bash
bundle install
```

The gem includes several tasks and generators. Run the `install` task to kick things off.

This task is responsible for setting the foundation for Rails UI, which includes assets, themes, theme-driven pages, and more.

The default theme for Rails UI is [Hound](https://railsui.com/themes/hound). It will install when you install Rails UI. You can change it any time.

```bash
rails railsui:install
```

After installing Rails UI, run your server using the `bin/dev` command and proceed to the configuration screen to customize your install (i.e. `localhost:3000/railsui` for new apps).

## Configuration

Configuration is a simple process where you configure your app's details (app name, support email), brand colors, and theme.

Each theme comes with different pages and are designed for different niches in mind. They reside in the `app/views/rui` directory once installed and should be treated as read-only.

**Updating your configuration at anytime will overwrite the pages and theme assets so if you want to keep your changes, you'll need to copy the files to your application in another directory.**

### Rake tasks

- `railsui:install` - Install Rails UI.
- `railsui:colors[theme]` - Pass a theme name to output default color palette or don't pass an argument to show active colors.
- `railsui:pages` - List all pages for the active theme.
- `railsui:pages[theme]` - List all pages for a theme name as passed.

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

Each theme comes with a custom color palette built on top of the default Tailwind CSS color palette. We've added two new colors for you to use in your app using Tailwind CSS classes called `primary` and `secondary`. You can change those colors any time in your railui.yml config file or in the configuration form.

Run `rails railsui:colors` to see your active colors or `rails "railsui:colors[theme]"` to see the default colors for a given theme.

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

Version 3 resides on the main branch.

```ruby
gem "railsui", github: "railsui/railsui", branch: "main"
```

## Frequently Asked Questions

[Read FAQs here](https://railsui.com/docs/faqs).
