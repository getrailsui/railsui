![Rails UI Docs](https://f001.backblazeb2.com/file/railsui/docs/rui-docs-header.png)

# Rails UI

Professionally designed templates and components for Ruby on Rails. Leverage breath-taking UI to fast-track your next idea.

### Links

- [Website](https://railsui.com)
- [Documentation](https://railsui.com/docs)
- [FAQs](https://railsui.com/docs/faqs)
- [Discussions](https://github.com/getrailsui/railsui/discussions)
- [Updates](https://railsui.com/updates)
- [Twitter](https://twitter.com/railsui_)

## Installation

#### New Rails Apps

For new apps, use the `-c tailwind` flag to install Tailwind CSS. Rails UI uses Tailwind CSS is required for styling.

It's recommended to use the `-j` flag to one of the bundling solutions from the [`jsbundling-rails`](https://github.com/rails/jsbundling-rails) gem (bun, esbuild rollup, webpack) for max compatibility.

Support for [importmaps](https://github.com/rails/importmap-rails) or [propshaft](https://github.com/rails/propshaft) is not currently available.

Example new app command:

```
rails new app_name -c tailwind -j bun
```

#### Existing Rails Apps

For Rails UI, Tailwind CSS is required for styling.
If you're adding Tailwind to an existing app, you may need to run if you never have before installing Rails UI:

```bash
/bin/bundle add tailwindcss-rails
/bin/rails tailwindcss:install
```

Your configuration may vary depending on your setup. So please refer to the [tailwindcss-rails documentation](https://github.com/rails/tailwindcss-rails) for more information.

#### New and existing Rails apps

Add the `railsui` gem to your Gemfile.

```ruby
# Gemfile
gem "railsui", github: "getrailsui/railsui", branch: "main"
```

```bash
bundle install
```

## Installation

Run the installer to install Rails UI. This will install the default theme [Hound](https://railsui.com/templates/hound) and generate a `railsui.yml` configuration file as well update the `tailwind.config.js` file in your application assuming it's in the root directory. If it's not, Rails UI will attempt to create one.

```bash
rails railsui:install
```

After installing Rails UI, run your server using the `bin/dev` command and proceed to the configuration screen to customize your install (i.e. `localhost:3000/railsui` for new apps).

## Configuration

Configuration is a simple process where you configure your app's details, brand colors, choose a theme, and install any one-off pages you want.

Each theme comes with different pages and are designed for different niches in mind. They reside in the `app/views/rui` directory once installed.

Updating your configuration at anytime will overwrite the pages so if you want to keep your changes, you'll need to copy the files to your application in another view directory.

### Rake tasks

- `railsui:install` - Install Rails UI.
- `railsui:colors[theme]` - Pass a theme name to output default color palette or don't pass an argument to show active colors.
- `railsui:pages` - List all pages for the active theme.

### Adding pages

Because we take a theme-first approach to design with Rails UI, you can install pre-designed one-off pages.

## Included components

After you configure Rails UI, you can preview the design system. Here you will find a collection of components and best practices for real-world usage of components and pages.

Use this as a guide to add a new design to your application, but please don't take it as gospel.

Design is less rigid than programming and often needs a little tweaking as you go. The goal is to give you a hell of a good head start.

## Updates

Run `bundle update railsui` from within your project and it should fetch the most recent version of the gem/engine directly from GitHub. I'll be tagging major releases once features are more solidified.

## Frequently Asked Questions

<details>
  <summary>What is Rails UI? </summary>

[Rails UI](https://railsui.com) is plug-and-play UI for Ruby on Rails applications. It takes a theme-based approach to product design and offers a suite of pre-designed components and pages for rails developer looking to move fast but look good doing so.

</details>

<details>
<summary>
  What happens during installation?
</summary>

Installing Rails UI is a quick process that goes something like this:

1. Install the gem
2. Run the installer `rails railsui:install`
3. Boot your server and load the Rails UI landing page and click "Configure app"
4. Set a application name, support email and choose a template.
5. Optionally install pre-designed pages bundled with your chosen template.

### Dependencies included by default

#### Gems

We keep the gem list simple because Rails UI focuses less on core application logic and more on design and styling.

- [rails](https://rubygems.org/gems/rails)
- [railsui_icon](https://rubygems.org/gems/railsui_icon)
- [meta-tags](https://rubygems.org/gems/meta-tags)

#### Icons

For all Rails UI themes and components, we leverage [heroicons](https://heroicons.com). These icons come in multiple variants which is useful for different design problems.

We recommend sticking with one library of icons and one variant for better consistency. Icons are sourced from another gem we made called [railsui_icon](https://rubygems.org/gems/railsui_icon) which is an added dependency of Rails UI. It should install when you install Rails UI but if it doesn't, you can install it manually.

```bash
bundle add railsui_icon
```

#### Email Templates

Rails UI includes a set of email templates for your disposal including a custom mailer layout.

You can find these in the `app/views/railsui_mailer` directory and the layout in `app/views/layouts/rui/railsui_mailer.html.erb`. You can customize these templates to your liking but treat them as read-only. We recommend copying these files to another view or directory in your application and customizing them there.

Updating your Rails UI configuration will overwrite these files.

</details>

<details>
  <summary>Is this an application template for Rails?</summary>

No. Well, kind of, but mostly this is a hybrid Rails engine not like other engines you've probably used. You can think of Rails UI as a source of truth for design elements, components, and views that significantly influence what your end users see when interacting with your app. It takes the guesswork out of the design problem.

**Rails UI is meant for brand new Rails applications.** You'll want to use it on the "first run" so you can establish the foundation for assets and design patterns early on. To use Rails UI you need to choose a theme (more themes coming soon) that will act as the basis for future design elements.

</details>

<details>
  <summary>What happens when I configure Rails UI? </summary>

- A custom configuration yaml file `railsui.yml` is added to your application in the `config` directory.
- Dependencies and any necessary assets are installed and/or copied to your application.
- A custom design system for repeatable web elements is inititalized. Think of this as a system for providing design direction when creating new features. This includes typography, font elements, and SVG icons.
- One-off pages are copied over (i.e. About us, Pricing, etc...). Use these as a starting point. Consider them read-only as updating your configuration will overide them.
- After installing the Rails UI gem and running the installer, you may configure your application preferences.
</details>

<details>
  <summary>Where are all the Turbo goodies?</summary>

We're just hitting ground with Rails UI so expect to see additional components and solutions in the future. We have loads of ideas but would always love to hear yours as well.

</details>

<details>
  <summary>Is this code open-sourced?</summary>

Rails UI it is free and clear to try out but not redistribute. There's a [pro version](https://railsui.com/pricing) that comes with more themes, components, and bells and whistles.

The _eventual_ license model will be a non-exclusive one, which essentially means you don't have permission to modify or share Rails UI as your own product but you can use it freely in your projects. New themes and components will be a part ongoing development.

</details>

## Updates

Rails UI ships as a gem. Future releases are available to clone/pull from a private git-hosted group to which you will have access if you purchase the pro version.

## Is it free?

Rails UI comes in two flavors, free and pro. The free version is available here. The [pro version](https://railsui.com/pricing) requires a subscription. We happily maintain both.

**Free**

The free version has a handful of templates and components anyone can make use of. You're looking at the free version currently.

**Premium**

The [pro version](https://railsui.com/pricing) contains both free and premium templates. This version includes exclusive templates, pages, components, and tools only subscribers have access to in addition to the free version.
