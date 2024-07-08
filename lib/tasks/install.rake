namespace :railsui do
  desc "Install Rails UI"
  task :install do
    system("#{RbConfig.ruby} ./bin/rails g railsui:install")
  end
end
