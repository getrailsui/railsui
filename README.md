![Rails UI Docs](https://f001.backblazeb2.com/file/railsui/docs/rui-docs-header.png)

# Rails UI

> Free while in alpha

Rails UI is a powerful tool for Ruby on Rails developers to enhance the design of their applications quickly and easily.

By providing pre-built and customizable UI components, Rails UI streamlines front-end development and allows developers to focus on building robust features that provide exceptional user experiences.

With Rails UI, you can easily bring professional-grade design to your Ruby on Rails applications, boosting engagement and improving user satisfaction.

### Links

- [Website](https://railsui.com)
- [Documentation](https://railsui.com/docs)
- [Discussions](https://github.com/getrailsui/railsui/discussions)
- [Twitter](https://twitter.com/railsui_)

## Installation

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

Use Rails UI for brand **new** Ruby on Rails applications for best results.

Configuration is a simple process that first prompts you for an application name and preferred CSS framework—following install of a CSS framework; you can choose a theme. Rails UI currently ships with support for Bootstrap and Tailwind CSS.

### Selecting a theme

After configuring your Rails UI install, you will see a series of themes. Choose your preferred theme and click "Save changes." Rails UI installs any assets, dependencies, and code related to the theme.

Note: The theme list will grow as Rails UI does.

### Adding pages

Because we take a theme-first approach to design with Rails UI, you can install pre-designed one-off pages. **Pages are a work in progress**, and each theme will have multiple available for install.

## Design system

After you configure Rails UI, you can preview the design system. There you will find a collection of components and best practices for real-world usage of your Rails UI theme. Use this as a guide to add a new design to your application, but please don't take it as gosple. Design is less rigid than programming and often needs a little tweaking as you go. My goal is to give you a hell of a good head start.

## Updates

While in alpha you can run `bundle update railsui` from within your project and it should fetch the most recent version of the gem/engine direct from GitHub. I'll be tagging major releases once features are more solidified.

## Frequently Asked Questions

<details>
  <summary>What is Rails UI? </summary>

[Rails UI](https://railsui.com) is plug-and-play UI for Ruby on Rails applications. It takes a theme-based approach to product design and offers a suite of pre-designed components and pages for rails developer looking to move fast but look good doing so.

</details>

<details>
<summary>
  What happens during installation?
</summary>

☕️ I'm glad you asked! Grab some coffee...and read on

Installing Rails UI is a quick process that goes something like this:

1. Install the gem
2. Run the installer `rails railsui:install`
3. Boot your server and load the Rails UI landing page and click "Configure app"
4. Choose an application name, support email, and CSS framework ([Bootstrap](https://getbootstrap.com), [Tailwind](https://tailwindcss.com)) and save your changes.
5. Choose a theme based on the previously chosen CSS framework
6. Optionally install pre-designed pages bundled with your chosen theme.
7. 🏄‍♀️ Done!

### Dependencies included by default

#### Gems

We keep the gem list simple because Rails UI focuses less on core application logic.
- [inline_svg](https://github.com/jamesmartin/inline_svg)
- [devise](https://github.com/heartcombo/devise)
- [name_of_person](https://github.com/basecamp/name_of_person)
- [meta-tags](https://github.com/kpumuk/meta-tags)
- [psych](https://github.com/ruby/psych)

#### Icons

For all Rails UI applications we leverage [heroicons](https://heroicons.com/). These icons cover a lot of basis and come in multiple variants which is useful for different design problems.

If you select Bootstrap as your CSS framework that comes with [Bootstrap Icons](https://icons.getbootstrap.com/) as an additional set of icons to leverage.

It's recommended to stick with one library of icons and one variant for better consistency.

### Installation detail

#### Install, configure, and customize Devise

[Devise](https://github.com/heartcombo/devise) is one of the more popular gems for authentication with Ruby on Rails. Rails UI ships with initial Devise support and assumes a `User` model exists in your app. On top of the default columns, we add a `first_name,` `last_name,` and `admin.`

Even if you use something other than `User,` you can go back after installation and change this since it's easy to do so early in the app's lifecycle.

Devise allows you to install independent views for customization. We took care of this with themed authentication templates ready to use. Check out the Authentication section of the design system to preview the experience.

#### Add name_of_person and avatar

Rails UI themes often leverage avatars for user accounts, so we bundled that logic into a `User` model.

We added the `first_name` and `last_name` attributes for use with the handy [name_of_person](https://github.com/basecamp/name_of_person) gem. This gem allows you to refer to users in different ways throughout your app quickly.

#### Remove importmaps as a default

Rails UI has some opinionated defaults when it comes to assets and JavaScript. Importmaps aren't our preference, so we use a custom approach.

[esbuild](https://esbuild.github.io/) is the default JavaScript build engine. Depending on your chosen CSS framework, we include those dependencies as well. Rails UI currently supports Bootstrap and Tailwind CSS.

#### Add ActiveStorage and ActionText support

Adding ActiveStorage and ActionText to Rails is simple but requires an additional step. Rails UI handles that for you, so you needn't worry about it.

#### Add esbuild + Stimulus.js

While there are many JavaScript solutions out there, the default with Rails is [Stimulus.js](https://stimulus.hotwired.dev/), so we've used the same tools to keep things simple.

#### Custom scaffolds and generators

Rails UI installs a custom template engine configured when installed. The engine hooks into the Rails generator logic and spits out themed scaffold templates when you generate a new resource. We found this saves loads of time that you can put better use elsewhere.

#### Custom mailer layout and mailer helpers

Designing a proper e-mail template takes a lot of work, and Rails UI takes out the guesswork of supporting many e-mail clients.

Bundled with your theme is a customized `mailer.html.erb` layout file and a few helpers to make coding additional e-mails easier. We've bundled a few templates to get you started, including a minimal, promotional, and transactional template. All Devise e-mails come ready to use too.

</details>

<details>
  <summary>Is this an application template for Rails?</summary>

No. Well, kind of, but mostly this is a hybrid Rails engine not like other engines you've probably used. You can think of Rails UI as a source of truth for design elements, components, and views that significantly influence what your end users see when interacting with your app. It takes the guesswork out of the design problem.

**Rails UI is meant for brand new Rails applications.** You'll want to use it on the "first run" so you can establish the foundation for assets and design patterns early on. To use Rails UI you need to choose a theme (more themes coming soon) that will act as the basis for future design elements.

</details>

<details>
  <summary>What happens when I configure Rails UI? </summary>

Once configured Rails UI will:

- Generate a custom configuration yaml file railsui.yml that's required to theme your new app.
- Install dependencies and any necessary assets.
- Generate a custom tailored design system for repeatable web elements. Think of this as a system for providing design direction when creating new features. This includes typography, font elements, and SVG icons.
- Optionally install one-off templates (i.e. About us, Pricing, etc...). Use these as a starting point.
- Install scaffold templates that follow the theme and CSS framework you chose.
- After installing the Rails UI gem and running the installer, you may configure your application preferences.
</details>

<details>
  <summary>Where are all the Turbo goodies?</summary>

We're just hitting ground with Rails UI so expect to see additional components and solutions in the future. We have loads of ideas but would always love to hear yours as well.

</details>

<details>
  <summary>Is this code open-sourced?</summary>

While we are kicking the tires with an alpha version of Rails UI it is free and clear to try out but not redistribute.

Our _evenutal_ license model will be a non-exclusive one in which essentially means you don't have permission to modify or share Rails UI but you can use it freely in your projects.

Eventually, when the official first release drops, an ongoing subscription is required in order to ship new themes and updates in an ongoing fashion.
</details>

## Updates

Rails UI ships as a gem. Future releases are available to clone/pull from a private git-hosted group of which you will have access to with an active subscription.

If you subscription lapses you can still use Rails UI but you lose access to ongoing updates and additional themes to choose from.

## Become an early supporter ❤️

Help shape the future of Rails UI as [an early supporter](https://railsui.com/pricing).

Save money and support ongoing development by locking in a less costly early supporter lifetime contribution. Your one-time purchase will help keep this project alive and thriving for years to come and you'll retain access to Rails UI for good.
