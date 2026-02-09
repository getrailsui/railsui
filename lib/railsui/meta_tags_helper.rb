# frozen_string_literal: true

module Railsui
  module MetaTagsHelper
    def railsui_meta_tags(options = {})
      defaults = {
        site: Railsui.config.application_name,
        title: nil,
        description: nil,
        image: "railsui/meta/opengraph.jpg",
        card_image: "railsui/meta/opengraph-mark.jpg",
        og_type: "website",
        card_type: "summary"
      }
      opts = defaults.merge(options)

      full_title = [opts[:title], opts[:site]].compact.join(" | ")
      og_image_url = opts[:image]&.start_with?("http") ? opts[:image] : image_url(opts[:image])
      card_image_url = opts[:card_image]&.start_with?("http") ? opts[:card_image] : image_url(opts[:card_image])

      safe_join([
        tag.meta(charset: "UTF-8"),
        tag.title(full_title),
        tag.meta(name: "viewport", content: "width=device-width, initial-scale=1"),
        tag.meta(name: "apple-mobile-web-app-capable", content: "yes"),
        tag.meta(name: "mobile-web-app-capable", content: "yes"),
        tag.meta(name: "description", content: opts[:description]),
        tag.link(rel: "canonical", href: request.original_url),
        # Open Graph
        tag.meta(property: "og:title", content: full_title),
        tag.meta(property: "og:type", content: opts[:og_type]),
        tag.meta(property: "og:url", content: request.original_url),
        tag.meta(property: "og:image", content: og_image_url),
        tag.meta(property: "og:description", content: opts[:description]),
        tag.meta(property: "og:site_name", content: opts[:site]),
        # Social Card (X/Twitter)
        tag.meta(name: "twitter:card", content: opts[:card_type]),
        tag.meta(name: "twitter:title", content: full_title),
        tag.meta(name: "twitter:description", content: opts[:description]),
        tag.meta(name: "twitter:image", content: card_image_url),
        # Favicons
        tag.link(rel: "icon", href: image_url("railsui/meta/favicon.svg"), type: "image/svg+xml"),
        tag.link(rel: "apple-touch-icon", href: image_url("railsui/meta/apple-touch-icon.png"))
      ].compact, "\n")
    end
  end
end
