module Themes
  module Hound
    class ButtonComponent < ViewComponent::Base
      attr_reader :text, :style, :type, :options, :size

      def initialize(text: nil, style: :primary, type: nil, size: nil, options: {})
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
        "#{btn_style} #{variant} #{options[:class]} gap-2"
      end

      def variant
        case size
        when :base
          "py-2 px-3 text-sm"
        when :sm
          "py-1 px-2 text-xs"
        when :lg
          "py-3 px-5 text-lg"
        end
      end

      private

      def btn_style
        case style
        when :primary
          button_primary
        when :secondary
          button_secondary
        when :white
          button_white
        when :dark
          button_dark
        when :transparent
          button_transparent
        when :link
          button_link
        else
          button_white
        end
      end

      def button_base
        "font-medium text-center rounded-md focus:ring-4 transition ease-in-out duration-300 no-underline inline-flex items-center justify-center"
      end

      def button_primary
        "#{button_base} bg-primary-500 hover:bg-primary-600 focus:ring-primary-500/20 text-white"
      end

      def button_secondary
        "#{button_base} bg-secondary-500 hover:bg-secondary-600 focus:ring-secondary-500/20 text-white"
      end

      def button_dark
        "#{button_base} bg-slate-800 hover:bg-slate-900 focus:ring-slate-800/20 text-white dark:hover:text-slate-100 dark:hover:bg-slate-700 dark:focus:ring-slate-800"
      end

      def button_white
        "#{button_base} bg-white hover:bg-white text-slate-700 focus:ring-slate-100 border border-slate-300 shadow-sm hover:border-slate-400 shadow-slate-300/20 hover:shadow-slate-300/50 dark:shadow-none dark:bg-slate-800/70 dark:text-slate-200 dark:border-slate-700 dark:focus:ring-slate-600/30 dark:hover:border-slate-600 dark:hover:bg-slate-800"
      end

      def button_transparent
        "#{button_base} hover:bg-slate-100 focus:ring-4 focus:ring-slate-200 hover:bg-opacity-90 shadow-none hover:ring-slate-200 border border-transparent hover:text-slate-800 text-slate-700 dark:text-slate-300 dark:hover:bg-slate-700 dark:hover:text-slate-100 dark:focus:ring-slate-800"
      end

      def button_link
        "text-primary-600 font-semibold focus:ring-transparent hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-500"
      end
    end
  end
end
