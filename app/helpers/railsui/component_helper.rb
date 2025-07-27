module Railsui
  module ComponentHelper
    def rui(name, **options, &block)
      component_class = component_class_for(name)
      render component_class.new(**options), &block
    end

    private

    def component_class_for(name)
      # Handle nested components like "accordion_item" or "accordion/item"
      class_name = if name.to_s.include?('/') || name.to_s.include?('_')
        # Convert "accordion/item" or "accordion_item" to "AccordionItem"
        parts = name.to_s.split(/[\/\_]/).map(&:classify)
        "Railsui::#{parts.join}Component"
      else
        "Railsui::#{name.to_s.classify}Component"
      end
      
      class_name.constantize
    rescue NameError => e
      raise ComponentNotFoundError.new(name, class_name, e)
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

  class ComponentNotFoundError < StandardError
    def initialize(component_name, class_name, original_error)
      super(<<~MSG)
        Rails UI component '#{component_name}' not found.
        
        Expected class: #{class_name}
        
        Available components:
        #{available_components.map { |c| "  - #{c}" }.join("\n")}
        
        Generate this component:
          rails g railsui:component #{component_name}
        
        Original error: #{original_error.message}
      MSG
    end

    private

    def available_components
      return [] unless defined?(Railsui)
      
      Railsui.constants
         .select { |c| 
           const = Railsui.const_get(c)
           const.is_a?(Class) && 
           const < ViewComponent::Base && 
           const.name.end_with?('Component') &&
           const != Railsui::BaseComponent # Exclude the base component
         }
         .map { |c| c.to_s.sub(/Component$/, '').underscore }
    rescue
      []
    end
  end
end
