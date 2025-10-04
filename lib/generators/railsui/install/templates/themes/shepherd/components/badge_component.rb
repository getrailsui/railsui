# frozen_string_literal: true

# Badge component for Rails UI
#
# Usage:
#   <%= rui :badge, "New" %>
#   <%= rui :badge, "Pro", variant: :blue, style: :pill %>
#   <%= rui :badge, variant: :green, size: :lg do %>
#     Custom content
#   <% end %>
#
# Options:
#   text: String - Badge text (can also be passed as first argument)
#   variant: Symbol - :gray, :red, :orange, :yellow, :green, :blue, :indigo, :purple, :pink, :white (default: :gray)
#   style: Symbol - :basic, :pill, :outline, :tag (default: :basic)
#   size: Symbol - :xs, :sm, :md, :lg (default: :md)
#   **html_options - Additional HTML attributes
module Rui
  class BadgeComponent < BaseComponent
    def initialize(
      text: nil,
      variant: :gray,
      style: :basic,
      size: :md,
      **html_options
    )
      @text = text
      @variant = variant.to_sym
      @style = style.to_sym
      @size = size.to_sym
      @html_options = html_options
    end

    private

    def badge_classes
      base_classes = "font-medium inline-flex items-center"
      style_classes = style_class
      size_classes = size_class
      custom_classes = @html_options[:class]

      [base_classes, style_classes, size_classes, custom_classes].compact.join(" ")
    end

    def html_attributes
      @html_options.except(:class)
    end

    def style_class
      case @style
      when :pill
        pill_classes
      when :outline
        outline_classes
      when :tag
        tag_classes
      else # :basic
        basic_classes
      end
    end

    def basic_classes
      base = "rounded"
      color = variant_colors[:basic]
      [base, color].join(" ")
    end

    def pill_classes
      base = "rounded-full"
      color = variant_colors[:basic]
      [base, color].join(" ")
    end

    def outline_classes
      base = "rounded border"
      color = variant_colors[:outline]
      [base, color].join(" ")
    end

    def tag_classes
      base = "rounded-sm"
      color = variant_colors[:basic]
      [base, color].join(" ")
    end

    def size_class
      case @size
      when :xs
        "px-1.5 py-0.5 text-[10px] leading-tight"
      when :sm
        "px-2 py-0.5 text-xs leading-tight"
      when :lg
        "px-3 py-1.5 text-sm"
      else # :md
        "px-2 py-1 text-xs"
      end
    end

    def variant_colors
      colors = case @variant
      when :red
        {
          basic: "bg-red-100 text-red-800 dark:bg-red-500/20 dark:text-red-300",
          outline: "border-red-200 text-red-800 dark:border-red-500/50 dark:text-red-300"
        }
      when :orange
        {
          basic: "bg-orange-100 text-orange-700 dark:bg-orange-500/20 dark:text-orange-300",
          outline: "border-orange-200 text-orange-700 dark:border-orange-500/50 dark:text-orange-300"
        }
      when :yellow
        {
          basic: "bg-yellow-100 text-yellow-700 dark:text-yellow-300 dark:bg-yellow-500/20",
          outline: "border-yellow-200 text-yellow-700 dark:border-yellow-500/50 dark:text-yellow-300"
        }
      when :green
        {
          basic: "bg-green-100 text-green-800 dark:text-green-300 dark:bg-green-500/20",
          outline: "border-green-200 text-green-800 dark:border-green-500/50 dark:text-green-300"
        }
      when :blue
        {
          basic: "bg-blue-100 text-blue-800 dark:text-blue-300 dark:bg-blue-500/20",
          outline: "border-blue-200 text-blue-800 dark:border-blue-500/50 dark:text-blue-300"
        }
      when :indigo
        {
          basic: "bg-indigo-100 text-indigo-800 dark:text-indigo-300 dark:bg-indigo-500/20",
          outline: "border-indigo-200 text-indigo-800 dark:border-indigo-500/50 dark:text-indigo-300"
        }
      when :purple
        {
          basic: "bg-purple-100 text-purple-800 dark:text-purple-300 dark:bg-purple-500/20",
          outline: "border-purple-200 text-purple-800 dark:border-purple-500/50 dark:text-purple-300"
        }
      when :pink
        {
          basic: "bg-pink-100 text-pink-800 dark:text-pink-300 dark:bg-pink-500/20",
          outline: "border-pink-200 text-pink-800 dark:border-pink-500/50 dark:text-pink-300"
        }
      when :white
        {
          basic: "bg-white text-zinc-800 border border-zinc-200 dark:border-none dark:bg-white/10 dark:text-white/80",
          outline: "border-zinc-200 text-zinc-800 dark:border-white/30 dark:text-white/80"
        }
      else # :gray
        {
          basic: "bg-zinc-100 text-zinc-800 dark:bg-zinc-500/20 dark:text-zinc-200",
          outline: "border-zinc-200 text-zinc-800 dark:border-zinc-500/50 dark:text-zinc-200"
        }
      end

      colors
    end
  end
end