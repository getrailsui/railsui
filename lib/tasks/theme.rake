namespace :railsui do
  namespace :theme do
    desc "Install Tailwind Rails UI themes"
    # TODO: We need 2 themes per framework with unique names
    task :tailwind do
      # system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/tailwind/install.rb",  __dir__)}"
    end

    desc "Install Bootstrap Rails UI themes"
    task :bootstrap do
      # system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/bootstrap/install.rb",  __dir__)}"
    end

    desc "Install Bulma Rails UI themes"
    task :bulma do
      # system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/bulma/install.rb",  __dir__)}"
    end
  end
end
