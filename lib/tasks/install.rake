namespace :railsui do
    desc "Install shared elements Rails UI CSS frameworks"
    task :install do
      system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/install.rb",  __dir__)}"
    end
  namespace :framework do
    namespace :install do

      desc "Install Tailwind for Rails UI"
      task :tailwind do
        system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/tailwind/install.rb",  __dir__)}"
      end

      desc "Install Bootstrap for Rails UI"
      task :bootstrap do
        system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/bootstrap/install.rb",  __dir__)}"
      end

      desc "Install Bulma for Rails UI"
      task :bulma do
        system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/bulma/install.rb",  __dir__)}"
      end
    end
  end
end
