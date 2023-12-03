require_dependency "railsui/application_controller"

module Railsui
  module Systems
    class ComponentsController < ApplicationController
      pages = %w[accordions alerts badges breadcrumbs buttons cards datalists dropdowns flash modals navigation pagination popovers tabs toasts tooltips]

      pages.each do |page|
        define_method(page) do
        end
      end
    end
  end
end
