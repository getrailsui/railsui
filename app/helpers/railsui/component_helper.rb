module Railsui
  module ComponentHelper
    def rui(name, **locals, &block)
      name = name.to_s

      paths = [
        "rui/components/#{name}",
        "components/#{name}"
      ]

      found_path = paths.find do |path|
        lookup_context.template_exists?(path, [], true)
      end

      unless found_path
        raise "Rails UI component '#{name}' not found in: #{paths.join(', ')}"
      end

      Rails.logger.debug "RailsUI: rendering #{found_path}" if Rails.env.development?

      content = block_given? ? capture(&block) : locals[:label]
      render partial: found_path, locals: locals.merge(content: content)
    end
  end
end
