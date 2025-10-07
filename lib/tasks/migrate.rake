namespace :railsui do
  desc 'Migrate from cssbundling-rails to tailwindcss-rails'
  task :migrate_to_tailwindcss_rails do
    puts "🔄 Migrating Rails UI to use tailwindcss-rails gem..."
    puts ""

    # Check if cssbundling-rails is present
    has_cssbundling = Gem::Specification.find_all_by_name('cssbundling-rails').any?

    if has_cssbundling
      puts "✓ Detected cssbundling-rails - will migrate to tailwindcss-rails"
    else
      puts "ℹ️  cssbundling-rails not found - you may already be using tailwindcss-rails"
    end

    puts ""
    puts "This migration will:"
    puts "  1. Install tailwindcss-rails gem (if not already installed)"
    puts "  2. Remove Tailwind CSS from package.json"
    puts "  3. Update Procfile.dev to use tailwindcss-rails"
    puts "  4. Keep your JavaScript bundling setup intact"
    puts ""
    puts "Your current build mode will be preserved (JS bundling continues working)"
    puts ""

    print "Continue? (y/n): "
    response = STDIN.gets.chomp.downcase

    unless response == 'y'
      puts "❌ Migration cancelled"
      exit
    end

    puts ""
    puts "Starting migration..."
    puts ""

    begin
      # Step 1: Install tailwindcss-rails
      unless Gem::Specification.find_all_by_name('tailwindcss-rails').any?
        puts "📦 Installing tailwindcss-rails gem..."
        unless system("bundle add tailwindcss-rails")
          raise "Failed to install tailwindcss-rails gem"
        end
        puts "✓ tailwindcss-rails installed"
      else
        puts "✓ tailwindcss-rails already installed"
      end

      # Step 2: Remove Tailwind from package.json
      package_json_path = Rails.root.join("package.json")
      if File.exist?(package_json_path)
        puts ""
        puts "📝 Updating package.json..."

        begin
          package_json = JSON.parse(File.read(package_json_path))
        rescue JSON::ParserError => e
          raise "Failed to parse package.json: #{e.message}"
        end

        removed_packages = []

        # Remove Tailwind-related packages
        tailwind_packages = ['tailwindcss', '@tailwindcss/cli', '@tailwindcss/typography', '@tailwindcss/forms', '@tailwindcss/aspect-ratio', '@tailwindcss/container-queries']

        if package_json['dependencies']
          tailwind_packages.each do |pkg|
            if package_json['dependencies'].delete(pkg)
              removed_packages << pkg
            end
          end
        end

        if package_json['devDependencies']
          tailwind_packages.each do |pkg|
            if package_json['devDependencies'].delete(pkg)
              removed_packages << pkg
            end
          end
        end

        # Remove build:css script
        if package_json['scripts']&.key?('build:css')
          package_json['scripts'].delete('build:css')
          puts "  - Removed 'build:css' script"
        end

        File.write(package_json_path, JSON.pretty_generate(package_json))

        if removed_packages.any?
          puts "  - Removed packages: #{removed_packages.join(', ')}"
        else
          puts "  - No Tailwind packages found to remove"
        end

        puts "✓ package.json updated"
      end

      # Step 3: Update Procfile.dev
      procfile_path = Rails.root.join("Procfile.dev")
      if File.exist?(procfile_path)
        puts ""
        puts "📝 Updating Procfile.dev..."

        procfile_content = File.read(procfile_path)

        # Replace CSS build commands
        updated_content = procfile_content.gsub(/^css:.*$/, 'css: bin/rails tailwindcss:watch')

        File.write(procfile_path, updated_content)
        puts "✓ Procfile.dev updated to use 'rails tailwindcss:watch'"
      else
        puts ""
        puts "⚠️  Procfile.dev not found - you may need to create one manually"
      end

      # Step 4: Run tailwindcss:install if needed
      unless File.exist?(Rails.root.join("app/assets/builds/.keep"))
        puts ""
        puts "🎨 Setting up Tailwind CSS..."
        begin
          system("bin/rails tailwindcss:install") || raise("tailwindcss:install failed")
          puts "✓ Tailwind CSS configured"
        rescue => e
          puts "⚠️  tailwindcss:install failed: #{e.message}"
          puts "You may need to run 'bin/rails tailwindcss:install' manually"
        end
      end

      # Step 4a: Create new CSS file for tailwindcss-rails v4
      old_css_path = Rails.root.join("app/assets/stylesheets/application.tailwind.css")
      new_css_path = Rails.root.join("app/assets/tailwind/application.css")

      if File.exist?(old_css_path)
        puts ""
        puts "📦 Setting up CSS for tailwindcss-rails v4..."

        # Create new directory
        FileUtils.mkdir_p(Rails.root.join("app/assets/tailwind"))

        unless File.exist?(new_css_path)
          # Create new Tailwind CSS file with v4 directives
          File.write(new_css_path, <<~CSS)
            @import "tailwindcss";

            /* Custom styles and imports go here */
          CSS
          puts "✓ Created new app/assets/tailwind/application.css"
        end

        puts ""
        puts "⚠️  IMPORTANT: Manual action required!"
        puts "  Your existing CSS file has been preserved:"
        puts "  → app/assets/stylesheets/application.tailwind.css"
        puts ""
        puts "  Please manually migrate any custom CSS, @import statements, or"
        puts "  legacy styles from the old file to:"
        puts "  → app/assets/tailwind/application.css"
        puts ""
        puts "  After migrating, you can safely delete the old file."
      elsif !File.exist?(new_css_path)
        # No old file exists, create fresh new file
        puts ""
        puts "📦 Creating CSS file for tailwindcss-rails v4..."

        FileUtils.mkdir_p(Rails.root.join("app/assets/tailwind"))
        File.write(new_css_path, <<~CSS)
          @import "tailwindcss";

          /* Custom styles and imports go here */
        CSS
        puts "✓ Created app/assets/tailwind/application.css"
      end

      # Step 5: Update Rails UI config
      config_path = Rails.root.join("config/railsui.yml")
      if File.exist?(config_path)
        puts ""
        puts "📝 Updating Rails UI configuration..."

        config = Psych.load_file(config_path, permitted_classes: [Hash, Railsui::Configuration])

        # Ensure build mode is set (default to 'build' since they were using cssbundling)
        unless config.is_a?(Hash) && config.key?('build_mode')
          config['build_mode'] = 'build' if config.is_a?(Hash)
        end

        File.write(config_path, config.to_yaml)
        puts "✓ Rails UI configuration updated"
      end
    rescue => e
      puts ""
      puts "❌ Migration failed: #{e.message}"
      puts ""
      puts "To retry manually:"
      puts "  1. bundle add tailwindcss-rails"
      puts "  2. Remove Tailwind packages from package.json"
      puts "  3. Update Procfile.dev: css: bin/rails tailwindcss:watch"
      puts "  4. bin/rails tailwindcss:install"
      puts "  5. Update config/railsui.yml"
      puts ""
      puts "For detailed instructions, see: MIGRATION_GUIDE.md"
      exit 1
    end

    puts ""
    puts "✅ Migration complete!"
    puts ""
    puts "Next steps:"
    puts "  1. Run 'bundle install' to ensure all gems are installed"
    puts "  2. Update layouts to use: stylesheet_link_tag 'tailwind' (instead of 'application')"
    puts "  3. Run 'bin/rails tailwindcss:build' to compile your CSS"
    puts "  4. Start your server with 'bin/dev'"
    puts ""
    puts "Your JavaScript bundling setup remains unchanged."
    puts "CSS is now handled by the faster tailwindcss-rails gem! 🚀"
  end
end
