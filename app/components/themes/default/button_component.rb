module Themes
  module Default
    class ButtonComponent < ViewComponent::Base
      attr_reader :text, :style, :type, :options, :size

      def initialize(text: nil, style: :primary, type: nil, options: {}, size: nil)
        @text = text
        @style = style
        @size = size || :base
        @type = type || default_button_type
        @options = options
      end

      def default_button_type
        style == :link ? :link : :button
      end

      def btn_classes
        "#{btn_style} #{variant} #{options[:classes]} gap-2"
      end

      def variant
        case size
        when :base
        when :sm
          "btn-sm"
        when :lg
          "btn-lg"
        end
      end

      private

      def btn_style
        case style
        when :primary
          "btn btn-primary"
        when :secondary
          "btn btn-secondary"
        when :white
          "btn btn-white"
        when :dark
          "btn btn-dark"
        when :transparent
          "btn btn-transparent"
        when :link
          "btn btn-link"
        else
          "btn btn-white"
        end
      end
    end
  end
end
