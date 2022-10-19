module Railsui
  module FrameworkHelper

   def framework_cdn_script
    if Railsui.config.css_framework ==  Railsui::Default::BOOTSTRAP
    '<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.min.js" integrity="sha384-IDwe1+LCz02ROU9k972gdyvl+AESN10+x7tBKgc9I5HFtuNz0wWnPclzo6p9vxnk" crossorigin="anonymous"></script>'.html_safe
      elsif Railsui.config.css_framework == Railsui::Default::TAILWIND_CSS
        # TODO: Add Tailwind CSS / JS
      else
      end
    end
  end
end
