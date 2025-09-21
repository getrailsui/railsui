# frozen_string_literal: true

module Rui
  module ComponentsHelper
    def rui(component, *args, **options, &block)
      # Handle flexible arguments - first arg can be text content
      if args.any? && args.first.is_a?(String)
        options[:text] = args.first
      end

      # Build component class name
      component_name = component.to_s.camelize
      component_class = "Rui::#{component_name}Component"

      # Try to constantize and render
      begin
        klass = component_class.constantize
        render klass.new(**options), &block
      rescue NameError => e
        raise ArgumentError, "Unknown Rails UI component: '#{component}'. Make sure Rui::#{component_name}Component exists."
      end
    end

    private

    # List of available components for better error messages
    def available_rui_components
      %i[
        accordion alert avatar badge breadcrumb button card dropdown modal
        pagination tab toast tooltip
      ]
    end
  end
end