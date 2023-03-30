# Rails UI

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/railsui`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'railsui', git: "<git link shared with you>"
```

And then execute:

```bash
$ bundle install
```

## Installation

Install base configuration and Rails UI engine:

```bash
$ rails railsui:install
```

After installing Rails UI run your server using the `bin/dev` command.

## Usage



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

- [cssbundling-rails](https://github.com/rails/cssbundling-rails)
- [devise](https://github.com/heartcombo/devise)
- [jsbundling-rails](https://github.com/rails/jsbundling-rails)
- [name_of_person](https://github.com/basecamp/name_of_person)
- [meta-tags](https://github.com/kpumuk/meta-tags)

#### Icons

For all Rails UI applications we leverage [heroicons](https://heroicons.com/). These icons cover a lot of basis and come in multiple variants which is useful for different design problems.

If you select Bootstrap as your CSS framework that comes with [Bootstrap Icons](https://icons.getbootstrap.com/) as an additional set of icons to leverage.

It's recommended to stick with one library of icons and one variant for better consistency.

### Installation steps

#### Install and configure Devise

[Devise](https://github.com/heartcombo/devise) is one of the more popular gems for authentication with Ruby on Rails. Rails UI ships with initial support for Devise and assumes there is a `User` model in your app. On top of the default columns we add an `first_name`, `last_name`, and `admin`.

Even if you use something other than `User` you can go back after install and change this since it's easy to do so early in the app's lifecycle.

#### Adds name_of_person and avatar

Rails UI themes often leverage avatars for user accounts so we bundled that logic into a `User` model.

A `first_name` and `last_name` attribute was also added for use with the handy [name_of_person](https://github.com/basecamp/name_of_person) gem. This gem allows you to refer to users' in different ways throughout your app with ease.

#### Remove importmaps as a default

Rails UI has some opinionated defaults when it comes to assets and JavaScript. We leverage both the [cssbundling-rails](https://github.com/rails/cssbundling-rails) and [jsbundling-rails](https://github.com/rails/jsbundling-rails). Importmaps aren't our preference so we opt to using these gems to compensate.

esbuild is the default JavaScript build engine. Depending on your chosen CSS framework we included those dependencies as well. Rails UI currently supports Bootstrap and Tailwind CSS.


#### Add ActiveStorage and ActionText support

Adding ActiveStorage and ActionText to Rails is quite simple but requires an additional step or two from the get go. This handles that for you so you needn't worry about it.



</details>


<details>
  <summary>Is this an application template for Rails?</summary>

  No. This is an engine that mounts to a pre-existing Rails application but not like other engines you've probably used. You can think of Rails UI as a source of truth for design elements, components, and views that play a big role in what your end users see when interacting with your app.

  **Rails UI is meant for brand new Rails applications.** You'll want to use it on the "first run" so you can establish the foundation for assets and design patterns early on. To use Rails UI you need to choose a theme (more themes coming soon) that will act as the basis for future design elements.
</details>
