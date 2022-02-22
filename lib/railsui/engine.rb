# loads all dependencies in .gempspec
Gem.loaded_specs['railsui'].dependencies.each do |d|
  require d.name
 end

 module Railsui
   class Engine < ::Rails::Engine
     isolate_namespace Railsui
     engine_name = "railsui"

     config.app_generators do |g|
       g.templates.unshift File.expand_path("../templates", __dir__)
       g.scaffold_stylesheet false
     end

     config.before_initialize do
       Railsui.config = Railsui::Configuration.load!
     end

     initializer 'railsui.setup' do |app|
        if Rails.env.development?
         config.assets.precompile << "railsui_manifest.js"
       end
     end
   end
 end
