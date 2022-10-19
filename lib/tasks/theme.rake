namespace :railsui do
  namespace :theme do
    namespace :tailwind do
      desc "Install Rails UI Tailwind CSS 'Hound' theme"
      task :hound do
        system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/tailwind/hound/install.rb",  __dir__)}"
      end

      desc "Install Rails UI Tailwind CSS 'Shepherd' theme"
      task :shepherd do
        system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/tailwind/shepherd/install.rb",  __dir__)}"
      end
    end

    namespace :bootstrap do
      desc "Install Rails UI Bootstrap 'Retriever' theme"
      task :retriever do
        system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/bootstrap/retriever/install.rb",  __dir__)}"
      end

      desc "Install Rails UI Bootstrap 'Setter' theme"
      task :setter do
        system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/bootstrap/retriever/install.rb",  __dir__)}"
      end
    end
  end
end
