# frozen_string_literal: true
# pass the theme name as an argument to this task like so:
# rake 'railsui:colors[theme_name]'
# or run the task without an argument to get the default theme colors

namespace :railsui do
  desc "Show Rails UI theme colors"
  task :colors, [:theme] => :environment do |t, args|
    # Default to Railsui.config.theme if no argument is provided
    theme = args.theme || Railsui.config.theme

    # Fetch the theme colors using Railsui::Colors
    colors = Railsui::Colors.theme_colors(theme.to_s)

    puts "Colors for #{theme.humanize} theme:"
    # Output the colors in YAML format
    puts colors.to_yaml
  end
end
