module Railsui
  module ComponentHelper
    def rui(name, **locals, &block)
      name = name.to_s

      uses_items = locals.key?(:items)

      # Figure out content only if block or content isn’t already given
      content =
        if block_given?
          capture(&block)
        elsif locals[:content].present?
          locals[:content]
        elsif !uses_items && locals[:label].present?
          locals[:label]
        end

      segments = name.split("/")
      folder = segments.first
      partial = segments.length == 1 ? folder : segments.last

      paths = [
        "rui/components/#{folder}/#{partial}",
        "components/#{folder}/#{partial}"
      ]

      found_path = paths.find do |path|
        lookup_context.template_exists?(path, [], true)
      end

      raise "Rails UI component '#{name}' not found in: #{paths.join(', ')}" unless found_path

      Rails.logger.debug "RailsUI: rendering #{found_path}" if Rails.env.development?
      render partial: found_path, locals: locals.merge(content: content)
    end

    # def rui(name, **locals, &block)
    #   name = name.to_s
    #   content = block_given? ? capture(&block) : (locals[:content] || locals[:label])

    #   segments = name.split("/")
    #   folder = segments.first
    #   partial = segments.length == 1 ? folder : segments.last

    #   paths = [
    #     "rui/components/#{folder}/#{partial}",
    #     "components/#{folder}/#{partial}"
    #   ]

    #   found_path = paths.find do |path|
    #     lookup_context.template_exists?(path, [], true)
    #   end

    #   raise "Rails UI component '#{name}' not found in: #{paths.join(', ')}" unless found_path

    #   Rails.logger.debug "RailsUI: rendering #{found_path}" if Rails.env.development?
    #   render partial: found_path, locals: locals.merge(content: content)
    # end

    # def rui(name, **locals, &block)
    #   name = name.to_s

    #   # Only assign content if block is given
    #   content = block_given? ? capture(&block) : nil

    #   segments = name.split("/")
    #   folder = segments.first
    #   partial = segments.length == 1 ? folder : segments.last

    #   paths = [
    #     "rui/components/#{folder}/#{partial}",
    #     "components/#{folder}/#{partial}"
    #   ]

    #   found_path = paths.find do |path|
    #     lookup_context.template_exists?(path, [], true)
    #   end

    #   raise "Rails UI component '#{name}' not found in: #{paths.join(', ')}" unless found_path

    #   Rails.logger.debug "RailsUI: rendering #{found_path}" if Rails.env.development?
    #   render partial: found_path, locals: locals.merge(content: content)
    # end
  end
end
