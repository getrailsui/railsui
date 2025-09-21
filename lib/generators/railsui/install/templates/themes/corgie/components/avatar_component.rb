# frozen_string_literal: true

# Avatar component for Rails UI
#
# Usage:
#   <%= rui :avatar, src: "/path/to/image.jpg", alt: "User" %>
#   <%= rui :avatar, initials: "JD", size: :lg %>
#   <%= rui :avatar, size: :xl, shape: :rounded %>
#   <%= rui :avatar %> <!-- Shows placeholder icon -->
#
# Options:
#   src: String - Image URL (if provided, shows image)
#   alt: String - Alt text for image (default: "Avatar")
#   size: Symbol - :xs, :sm, :md, :lg, :xl, :"2xl", :"3xl" (default: :md)
#   shape: Symbol - :circle, :square, :rounded (default: :circle)
#   initials: String - User initials (if no src provided, shows initials)
#   **html_options - Additional HTML attributes
module Rui
  class AvatarComponent < BaseComponent
    def initialize(
      src: nil,
      alt: "Avatar",
      size: :md,
      shape: :circle,
      initials: nil,
      **html_options
    )
      @src = src
      @alt = alt
      @size = size.to_sym
      @shape = shape.to_sym
      @initials = initials
      @html_options = html_options
    end

    private

    def avatar_classes
      base_classes = "object-cover shrink-0"
      size_classes = size_class
      shape_classes = shape_class
      custom_classes = @html_options[:class]

      [base_classes, size_classes, shape_classes, custom_classes].compact.join(" ")
    end

    def html_attributes
      @html_options.except(:class)
    end

    def html_attributes_hash
      @html_options.except(:class)
    end

    def size_class
      case @size
      when :xs then "size-6"
      when :sm then "size-8"
      when :lg then "size-16"
      when :xl then "size-20"
      when :"2xl" then "size-24"
      when :"3xl" then "size-32"
      else "size-12" # :md
      end
    end

    def shape_class
      case @shape
      when :square then "rounded-none"
      when :rounded then "rounded-lg"
      else "rounded-full" # :circle
      end
    end

    def initials_classes
      base_classes = "flex items-center justify-center bg-gray-300 dark:bg-gray-600"
      size_classes = size_class
      shape_classes = shape_class
      custom_classes = @html_options[:class]

      [base_classes, size_classes, shape_classes, custom_classes].compact.join(" ")
    end

    def initials_text_class
      case @size
      when :xs then "text-xs font-medium text-gray-700 dark:text-gray-300"
      when :sm then "text-sm font-medium text-gray-700 dark:text-gray-300"
      when :lg then "text-lg font-medium text-gray-700 dark:text-gray-300"
      when :xl then "text-xl font-semibold text-gray-700 dark:text-gray-300"
      when :"2xl" then "text-2xl font-semibold text-gray-700 dark:text-gray-300"
      when :"3xl" then "text-3xl font-bold text-gray-700 dark:text-gray-300"
      else "text-sm font-medium text-gray-700 dark:text-gray-300" # :md
      end
    end

    def placeholder_classes
      base_classes = "flex items-center justify-center bg-gray-300 dark:bg-gray-600"
      size_classes = size_class
      shape_classes = shape_class
      custom_classes = @html_options[:class]

      [base_classes, size_classes, shape_classes, custom_classes].compact.join(" ")
    end

    def placeholder_icon_class
      icon_size = case @size
      when :xs then "size-3"
      when :sm then "size-4"
      when :lg then "size-8"
      when :xl then "size-10"
      when :"2xl" then "size-12"
      when :"3xl" then "size-16"
      else "size-6" # :md
      end

      "#{icon_size} text-gray-500 dark:text-gray-400"
    end
  end
end