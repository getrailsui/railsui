module Railsui
  module ComponentHelper
    def rui(name, **locals, &block)
      name = name.to_s
      theme = Railsui.config.theme || 'hound' # fallback to hound

      uses_items = locals.key?(:items)
      uses_form = locals.key?(:form)

      content =
        if block_given?
          capture(&block)
        elsif locals[:content].present?
          locals[:content]
        elsif !uses_items && !uses_form && locals[:label].present?
          locals[:label]
        end

      segments = name.split("/")
      folder = segments.first
      partial = segments.length == 1 ? folder : segments.last

      paths = [
        "rui/components/#{theme}/#{folder}/#{partial}",
        "rui/components/#{folder}/#{partial}",
        "components/#{theme}/#{folder}/#{partial}",
        "components/#{folder}/#{partial}"
      ]

      found_path = paths.find do |path|
        lookup_context.template_exists?(path, [], true)
      end

      raise "Rails UI component '#{name}' not found in: #{paths.join(', ')}" unless found_path

      Rails.logger.debug "RailsUI: rendering #{found_path} (theme: #{theme})" if Rails.env.development?
      render partial: found_path, locals: locals.merge(content: content)
    end

    # Helper to create forms with RailsUI form builder
    def railsui_form_with(model: nil, **options, &block)
      options[:builder] = Railsui::FormBuilder
      form_with(model: model, **options, &block)
    end

    # Alternative syntax
    def railsui_form_for(record, **options, &block)
      options[:builder] = Railsui::FormBuilder
      form_for(record, **options, &block)
    end
  end
end
