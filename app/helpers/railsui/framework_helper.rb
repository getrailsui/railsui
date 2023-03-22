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
      content_tag :div, class: "bg-slate-200 rounded-full px-2 py-px font-semibold text-xs flex items-center" do
        Railsui.bootstrap? ? Railsui::Default::BOOTSTRAP_VERSION : Railsui::Default::TAILWIND_CSS_VERISON
      end
    end


    def system_pagination(options={})
      render partial: "railsui/shared/pagination", locals: options
    end
  end
end
