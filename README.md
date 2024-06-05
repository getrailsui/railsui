![Rails UI Docs](https://f001.backblazeb2.com/file/railsui/docs/rui-docs-header.png)

# Rails UI

Rails UI brings professional design to your Ruby on Rails applications, boosting engagement and improving user satisfaction.

### Links

- [Website](https://railsui.com)
- [Documentation](https://railsui.com/docs)
- [FAQs](https://railsui.com/docs/faqs)
- [Discussions](https://github.com/getrailsui/railsui/discussions)
- [Updates](https://railsui.com/updates)
- [Twitter](https://twitter.com/railsui_)

## Installation

> [!IMPORTANT]
> Rails UI is for fresh Rails installs. Adding it to your existing app _could_ work but we assume a blank slate.

At this time Rails UI does not support installation alongside something like Jumpstart Pro or Bulletrain, which serve their own front-ends.

#### Create a new vanilla app

```
rails new my_app
```

- We recommend **not** configuring any front-end dependencies on the fly by passing options.

- Passing options like `--css`, `-c`, `--javascript`, `-j` are not necessary as the Rails UI installer takes care of this automatically.

- Other options are fair game such as tests, database type, etc...

**Pre-requisites**

Before installing the gem, ensure both your node and [yarn](https://yarnpkg.com/) versions are up to date for best results. Using something like [nvm](https://github.com/nvm-sh/nvm) helps with node versions. I like to use [homebrew](https://brew.sh/) for yarn and periodically run `brew upgrade yarn`.

```ruby
# Gemfile
gem "railsui", github: "getrailsui/railsui", branch: "main"
```

```bash
$ bundle install
```

## Installation

Install base configuration and Rails UI engine:

```bash
$ rails railsui:install
```

After installing Rails UI, run your server using the `bin/dev` command and proceed to the configuration screen.

## Configuration

Configuration is a simple process that first prompts you for an application name, support email, and template.

### Selecting a template

After configuring your Rails UI install, you will see a series of templates (more to come!). Choose your preferred template and submit the form. Rails UI installs any assets, dependencies, and code related to the theme. Once installed you can customize your template's default brand colors.

### Adding pages

Because we take a theme-first approach to design with Rails UI, you can install pre-designed one-off pages. **Pages are a work in progress**, and each theme will have multiple available for install.

## Included design patterns

After you configure Rails UI, you can preview the design system. There you will find a collection of components and best practices for real-world usage of your Rails UI template. Use this as a guide to add a new design to your application, but please don't take it as gospel. Design is less rigid than programming and often needs a little tweaking as you go. The goal is to give you a hell of a good head start.

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

We keep the gem list simple because Rails UI focuses less on core application logic.
      
- [rails](https://rubygems.org/gems/rails)
- [name_of_person](https://rubygems.org/gems/name_of_person)
- [devise](https://rubygems.org/gems/devise)
- [inline_svg](https://rubygems.org/gems/inline_svg)
- [meta-tags](https://rubygems.org/gems/meta-tags)
- [cssbundling-rails](https://rubygems.org/gems/cssbundling-rails)
- [jsbundling-rails](https://rubygems.org/gems/jsbundling-rails)

#### Icons

For all Rails UI applications we leverage [heroicons](https://heroicons.com). These icons cover a lot of basis and come in multiple variants which is useful for different design problems. We recommended sticking with one library of icons and one variant for better consistency.

### Installation details

#### Setup and Configuration
      
- Install and configure Devise for authentication.
- Add first_name, last_name, and admin columns to the User model.
- Include pre-designed authentication and mailer views for Devise to save loads of time.

#### User model

- Add name_of_person and avatar attributes.
- Leverage avatars for user accounts.
- Use the `name_of_person` gem for flexible user references.

#### JavaScript
      
- Replace importmaps with esbuild as the default JavaScript build engine.
      
#### ActiveStorage and ActionText
      
- Add ActiveStorage and ActionText support for rich text editing.


#### Frontend Tools

- Use Stimulus.js for JavaScript functionality.
- Install custom scaffolds and generators based on installed template.
- Tailwind CSS for styles.
  
#### Email Templates
      
- Include a custom mailer layout and helpers for easy email design and coding.
- Provide pre-built email templates (minimal, promotional, transactional) and Devise email support.

</details>

<details>
  <summary>Is this an application template for Rails?</summary>

No. Well, kind of, but mostly this is a hybrid Rails engine not like other engines you've probably used. You can think of Rails UI as a source of truth for design elements, components, and views that significantly influence what your end users see when interacting with your app. It takes the guesswork out of the design problem.

**Rails UI is meant for brand new Rails applications.** You'll want to use it on the "first run" so you can establish the foundation for assets and design patterns early on. To use Rails UI you need to choose a theme (more themes coming soon) that will act as the basis for future design elements.

At this time Rails UI does not integrate directly with application templates like Jumpstart Pro or Bulletrain. Most templates come with some form of their own front-end and that leads to too many conflicts.

</details>

<details>
  <summary>What happens when I configure Rails UI? </summary>

Once configured Rails UI will:

- Generate a custom configuration yaml file railsui.yml that's required to theme your new app.
- Install dependencies and any necessary assets.
- Generate a custom tailored design system for repeatable web elements. Think of this as a system for providing design direction when creating new features. This includes typography, font elements, and SVG icons.
- Optionally install one-off templates (i.e. About us, Pricing, etc...). Use these as a starting point.
- Install scaffold templates that follow the theme you chose.
- After installing the Rails UI gem and running the installer, you may configure your application preferences.
</details>

<details>
  <summary>Where are all the Turbo goodies?</summary>

We're just hitting ground with Rails UI so expect to see additional components and solutions in the future. We have loads of ideas but would always love to hear yours as well.

</details>

<details>
  <summary>Is this code open-sourced?</summary>

While we are kicking the tires with an alpha version of Rails UI it is free and clear to try out but not redistribute.

Our _eventual_ license model will be a non-exclusive one, which essentially means you don't have permission to modify or share Rails UI as your own product but you can use it freely in your projects.

Eventually, when the official premium version drops, there will be a private space to access ongoing updates via git. New themes and more will be a part of that in an ongoing fashion.

</details>

## Updates

Rails UI ships as a gem. Future releases are available to clone/pull from a private git-hosted group to which you will have access if you purchase the premium version.


## Is it free?

Rails UI comes in two flavors, free and premium. The free version is available here. The premium version requires a subscription. We happily maintain both.

**Free**

The free version has a handful of templates and components anyone can make use of. You're looking at the free version currently.

**Premium**

The [premium version](https://railsui.com/pricing) contains both free and premium templates. This version includes exclusive templates, pages, components, and tools only subscribers have access to.
