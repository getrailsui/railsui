namespace :railsui do
  namespace :theme do
    desc "Install Rails UI Tailwind CSS 'Hound' theme"
    task :hound do
      system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/tailwind/hound/install.rb",  __dir__)}"
    end

    desc "Install Rails UI Tailwind CSS 'Shepherd' theme"
    task :shepherd do
      system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/tailwind/shepherd/install.rb",  __dir__)}"
    end
  end
end
