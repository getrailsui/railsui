# frozen_string_literal: true

module Rui
  class BaseComponent < ViewComponent::Base
    include Railsui::ApplicationHelper

    private

    def theme
      Railsui.config.theme.downcase.to_s
    end
  end
end