# frozen_string_literal: true

# Property list component for displaying property listings
#
# Usage:
#   <%= rui :property_list, selectable: true do |list| %>
#     <% list.with_property(
#       property_image: image_url('property-1.jpg'),
#       title: "Cozy Mountain A-Frame",
#       subtitle: "Nature's Nook",
#       avatar_url: demo_avatar_url(id: 32),
#       selectable: true
#     ) %>
#   <% end %>
module Rui
  class PropertyListComponent < BaseComponent
    renders_many :properties, PropertyItemComponent

    def initialize(selectable: false, **html_options)
      @selectable = selectable
      @html_options = html_options
    end

    private

    def wrapper_classes
      "text-left my-8"
    end

    def html_attributes
      attrs = @html_options
      if @selectable
        attrs[:data] ||= {}
        attrs[:data][:controller] = "railsui-select-all"
      end
      attrs
    end
  end

  class PropertyItemComponent < BaseComponent
    def initialize(
      property_image:,
      title:,
      subtitle:,
      avatar_url:,
      avatar_alt: "Host",
      selectable: false,
      **html_options
    )
      @property_image = property_image
      @title = title
      @subtitle = subtitle
      @avatar_url = avatar_url
      @avatar_alt = avatar_alt
      @selectable = selectable
      @html_options = html_options
    end

    attr_reader :property_image, :title, :subtitle, :avatar_url, :avatar_alt, :selectable
  end
end