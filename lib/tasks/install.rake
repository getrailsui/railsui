namespace :railsui do
  desc "Install shared elements Rails UI CSS frameworks"
  task :install do
    system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/install.rb",  __dir__)}"
  end
end
