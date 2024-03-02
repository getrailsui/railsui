module Railsui
  module FrameworkHelper
    def framework_version_label
      content_tag :div, framework_version, class: "bg-slate-200 rounded-full px-2 py-px font-semibold text-xs flex items-center dark:bg-slate-700 dark:text-slate-100"
    end

    def framework_version
      package_version = nil
      version = File.open(Rails.root.join("package.json")) do |f|
        f.each_line do |line|
          if line =~ /"tailwindcss"/
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
