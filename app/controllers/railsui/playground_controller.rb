require_dependency "railsui/application_controller"

module Railsui
  class PlaygroundController < ApplicationController
    def index
      @components = available_components
    end

    def show
      @component_name = params[:component]
      @component_class = "Rui::#{@component_name.camelize}Component"

      unless component_exists?
        redirect_to railsui_playground_index_path, alert: "Component not found: #{@component_name}"
      end
    end

    private

    def available_components
      [
        { name: 'accordion', title: 'Accordion', description: 'Collapsible content sections' },
        { name: 'alert', title: 'Alert', description: 'System messages and notifications' },
        { name: 'avatar', title: 'Avatar', description: 'User profile images with fallbacks' },
        { name: 'badge', title: 'Badge', description: 'Status indicators and labels' },
        { name: 'breadcrumb', title: 'Breadcrumb', description: 'Navigation breadcrumbs' },
        { name: 'button', title: 'Button', description: 'Interactive buttons with variants' },
        { name: 'card', title: 'Card', description: 'Content containers' },
        { name: 'dropdown', title: 'Dropdown', description: 'Contextual menus' },
        { name: 'modal', title: 'Modal', description: 'Dialog overlays' },
        { name: 'pagination', title: 'Pagination', description: 'Page navigation controls' },
        { name: 'tab', title: 'Tab', description: 'Tabbed interfaces' },
        { name: 'toast', title: 'Toast', description: 'Temporary notifications' },
        { name: 'tooltip', title: 'Tooltip', description: 'Hover information' }
      ]
    end

    def component_exists?
      @component_class.constantize
      true
    rescue NameError
      false
    end
  end
end