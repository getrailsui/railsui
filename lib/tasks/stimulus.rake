namespace :stimulus do
  namespace :manifest do
    # Clear :update task to skip default behavior from stimulus-rails gem
    Rake::Task[:update].clear
    desc "Overwrite the default manifest update behavior to do nothing"
    task update: :environment do
      alert = %(
        Skipping stimulus:manifest:update to avoid overwriting index.js
      ).strip
      puts "\e[33m#{alert}\e[0m"
    end
  end
end
