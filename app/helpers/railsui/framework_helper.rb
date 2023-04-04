module Railsui
  module FrameworkHelper

   def framework_cdn_script
    if Railsui.config.css_framework ==  Railsui::Default::BOOTSTRAP
    '<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>'.html_safe
      elsif Railsui.config.css_framework == Railsui::Default::TAILWIND_CSS
        # TODO: Add Tailwind CSS / JS
      else
      end
    end

    def framework_version_label
      return nil unless Railsui.config.css_framework.present?
      content_tag :div, framework_version, class: "bg-slate-200 rounded-full px-2 py-px font-semibold text-xs flex items-center dark:bg-slate-700 dark:text-slate-100"
    end

    def framework_version
      package_version = nil
      version = File.open(Rails.root.join("package.json")) do |f|
        f.each_line do |line|
          if line =~ /"tailwindcss"/ || line =~ /"bootstrap"/
            package_version = line.match(/(?<=\")[^\"]*\d+\.\d+\.\d+[^\s,\"]*/)[0]
          end
        end
      end
      package_version
    end


    def system_pagination(options={})
      render partial: "railsui/shared/pagination", locals: options
    end
  end
end
