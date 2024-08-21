# frozen_string_literal: true

namespace :railsui do
  desc "Show Rails UI theme pages"
  task :pages, [:theme] => :environment do |t, args|
    # Default to Railsui.config.theme if no argument is provided
    theme = args.theme || Railsui.config.theme

    # Fetch the theme colors using Railsui::Colors
    pages = Railsui.config.pages

    puts "Page list for #{theme.humanize} theme:"
    # Output the colors in YAML format
    puts pages.to_yaml
  end
end
