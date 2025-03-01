module Railsui
  module ApplicationHelper
    def nav_link_to(name = nil, options = {}, html_options = {}, &block)
      if block
        html_options = options
        options = name
        name = block
      end

      url = url_for(options)
      starts_with = html_options.delete(:starts_with)
      html_options[:class] = Array.wrap(html_options[:class])
      active_class = html_options.delete(:active_class) || "nav-link-active"
      inactive_class = html_options.delete(:inactive_class) || ""

      active = if (paths = Array.wrap(starts_with)) && paths.present?
        paths.any? { |path| request.path.start_with?(path) }
      else
        request.path == url
      end

      classes = active ? active_class : inactive_class
      html_options[:class] << classes unless classes.empty?

      html_options.except!(:class) if html_options[:class].empty?

      return link_to url, html_options, &block if block

      link_to name, url, html_options
    end

    def theme_preview_link(theme)
      case theme
      when Railsui::Default::THEMES[:hound]
        Railsui::Default::THEME_PREVIEW_LINK[:hound]
      when Railsui::Default::THEMES[:shepherd]
        Railsui::Default::THEME_PREVIEW_LINK[:shepherd]
      else
        nil
      end
    end

    def code(code)
      content_tag :span, html_escape(code), class: "text-neutral-900 font-mono font-semibold text-[15px] dark:text-rose-400 bg-neutral-100 px-1 py-px dark:bg-transparent rounded whitespace-pre"
    end

    def render_snippet(options={})
      active_tab = options[:active_tab] ||= "html"
      html_filename = options[:html_filename] ||= ".html"
      erb_filename = options[:erb_filename] ||= ".html.erb"
      haml_filename = options[:haml_filename] ||= ".haml.erb"
      js_filename = options[:js_filename] ||= ".js"
      ruby_filename = options[:ruby_filename] ||= ".rb"
      css_filename = options[:css_filename] ||= ".css"


      render partial: "railsui/shared/snippet", locals: {
        active_tab: active_tab,
        html_filename: html_filename,
        erb_filename: erb_filename,
        haml_filename: haml_filename,
        js_filename: js_filename,
        ruby_filename: ruby_filename,
        css_filename: css_filename
      }
    end

    def theme_name
      Railsui.config.theme
    end

    def theme_key
      theme_name.to_sym
    end

    def heading(options={})
      text = options[:text] || "Enter some text"
      tag = options[:tag] || :h2
      id = options[:id]
      classes = options[:class]

      content_tag tag.to_sym, text, id: id, class: "#{classes} tracking-[-0.025em]"
    end

    def email_viewer(subject="A sample subject", &block)
      render "railsui/shared/rui_email_preview", subject: subject, block: block, flush: true
    end

    def box_label_classes(options={})
      "rounded-lg bg-white shadow-sm border border-slate-200 block select-none hover:shadow-none group bg-gradient-to-br from-white to-slate-50 dark:from-slate-700 dark:to-slate-800 dark:border-slate-600 dark:shadow-sm #{options[:offset] == false ? "px-4 pb-4 pt-1" : "p-4" }"
    end

    def box_check_classes
      "text-indigo-600 form-checkbox rounded focus:outline-hidden ring-2 ring-transparent focus:ring-slate-100  mr-2 border-slate-500 size-5
      focus:dark:ring-slate-700
      focus:dark:ring-opacity-20
      focus:dark:bg-slate-600  dark:bg-slate-700
      dark:ring-transparent"
    end

    def help_text &block
      content_tag :div, class: "prose prose-sm prose-neutral dark:prose-invert max-w-full" do
        yield
      end
    end

    def doc_label(type)
      case type
      when :javascript
        content_tag :p, "JavaScript", class:"bg-yellow-300 text-black rounded-full px-3 py-1 font-semibold inline-block text-xs mb-3"
      when :stimulus
        content_tag :p, "Stimulus.js", class: "bg-yellow-300 text-black rounded-full px-3 py-1 font-semibold inline-block text-xs mb-3"
      when :ruby
        content_tag :p, "Ruby", class: "bg-red-700 text-white rounded-full px-3 py-1 font-semibold inline-block text-xs mb-3"
      when :tutorial
        content_tag :p, "Tutorial", class: "bg-blue-500 text-white rounded-full px-3 py-1 font-semibold inline-block text-xs mb-3"
      when :demo
        content_tag :p, "Demo", class: "bg-emerald-50 text-emerald-600 rounded-full px-3 py-1 font-semibold inline-block text-xs mb-3"
      end
    end

    def callout
      "railsui/shared/callout"
    end

    def preview(variant = nil)
      case variant
      when "base"
        "railsui/shared/preview"
      when "zinc"
        "railsui/shared/preview_zinc"
      when "dark_zinc"
        "railsui/shared/preview_dark_zinc"
      when "gray"
        "railsui/shared/preview_gray"
      when "dark"
        "railsui/shared/preview_dark"
      else
        "railsui/shared/preview"
      end
    end

    def quick_link(title: nil, component: nil)
      content_tag :li do
        link_to title.capitalize, "##{component.parameterize}-#{title.parameterize}", class: "text-sm py-1 px-3 rounded font-medium inline-block bg-white border border-slate-300 hover:shadow-sm hover:border-slate-400 dark:border-slate-700 dark:bg-slate-800 dark:hover:border-slate-600 dark:hover:bg-slate-700/80 transition ease-in-out duration-200", data: { action: "click->railsui-smooth#scroll" }
      end
    end

    def route_verb_classes(verb)
      case verb
      when "GET"
        "bg-indigo-50 text-indigo-500 dark:bg-indigo-400/50 dark:text-indigo-100"
      when "PATCH"
        "bg-cyan-50 text-cyan-500 dark:bg-cyan-400/50 dark:text-cyan-100"
      when "PUT"
        "bg-amber-50 text-amber-500 dark:bg-amber-400/50 dark:text-amber-100"
      when "POST"
        "bg-emerald-50 text-emerald-500 dark:bg-emerald-400/50 dark:text-emerald-100"
      when "DELETE"
        "bg-rose-50 text-rose-500 dark:bg-rose-400/50 dark:text-rose-100"
      else
        "bg-slate-50 text-slate-500 dark:bg-slate-700 dark:text-slate-100"
      end
    end

    def tag_label(tag)
      base_classes = "rounded text-xs px-1 py-px font-semibold inline-flex items-center justify-center"

      case tag
      when "marketing"
        content_tag :div, tag.humanize, class: "#{base_classes} bg-indigo-50 text-indigo-500 dark:bg-indigo-500/40 dark:text-indigo-200"
      when "admin"
        content_tag :div, tag.humanize, class: "#{base_classes} bg-sky-50 text-sky-500 dark:bg-sky-500/40 dark:text-sky-200"
      else
        content_tag :div, tag.humanize, class: "#{base_classes} bg-slate-50 text-slate-500 dark:bg-slate-500/40 dark:text-slate-200"
      end
    end

    def theme_colors(group,val)
      Railsui::Default::THEME_COLORS[Railsui.config.theme.to_sym][group][val]
    end

    def example
      "railsui/shared/code_example"
    end

    def component_link(name, href)
      content_tag :li do
        link_to name, href, class: "block py-0.5 text-neutral-500 hover:text-neutral-900 dark:text-neutral-400 dark:hover:text-white truncate", data: {
          action: "click->railsui-smooth#scroll",
          railsui_scroll_spy_target: "link"
        }
      end
    end

    def divider
      content_tag :hr, nil, class: "my-6 dark:border-neutral-700/80 border-neutral-200/70"
    end

    def system_nav_item(label:, path:)
      render "railsui/shared/system_nav_item", label: label, path: path
    end

    def engine_icon_path(icon_path)
      "/#{Railsui::Engine.root.join("app/assets/images/#{icon_path}")}"
    end

    def rui_badge(label, variant: :blue)
      variant_class = case variant
        when :blue
          "bg-blue-500 text-white"
        when :green
          "bg-green-500 text-white"
        when :red
          "bg-red-500 text-white"
        when :yellow
          "bg-yellow-500 text-black"
        when :gray
          "bg-neutral-200 text-neutral-700"
      end
      content_tag :div, label, class: "#{variant_class} rounded-full px-2 py-1 text-xs font-semibold inline-flex my-0"
    end

    def input_classes
      "rounded-md px-4 py-2 border border-neutral-300/80 bg-white focus:border-neutral-500/80 focus:ring-4 focus:ring-neutral-100/80 focus:shadow-none focus:outline-hidden dark:bg-neutral-800 dark:border-neutral-700/80 dark:focus:border-neutral-500 placeholder-neutral-500/60 dark:focus:ring-neutral-500/40 dark:placeholder:text-neutral-300/60 font-normal antialiased font-sans w-full dark:text-neutral-50 text-neutral-800"
    end

    def label_classes
      "block mb-2 font-medium text-[14px] dark:text-white"
    end

    def button_classes(variant: "black", size: "md")
      base_classes = "rounded-md px-3 py-[5px] ring-4 ring-transparent text-base transition-colors ease-in-out duration-300 disabled:opacity-50 disabled:pointer-events-none disabled:cursor-not-allowed text-center text-[14.5px] font-semibold inline-flex gap-2 items-center justify-center"

      size_classes = case size
      when "lg"
        "py-3 px-6 text-lg"
      when "sm"
        "py-0.5 px-3 text-[13.5px]"
      else # md
        "py-[5px] px-3 text-[14.5px]"
      end

      variant_classes = case variant
      when "white"
        "bg-white hover:bg-neutral-50/50 hover:shadow-none shadow-xs text-neutral-800/80 border border-neutral-300 shadow-neutral-300/20 focus:ring-4 hover:border-neutral-600/40 focus:ring-neutral-100/70 focus:border-neutral-300/90 dark:bg-neutral-700/60 dark:text-white dark:border-neutral-500/30 dark:shadow-neutral-950/40 dark:hover:bg-neutral-800/90 dark:focus:ring-neutral-700/80 dark:focus:border-neutral-500/80"
      when "offwhite"
        "bg-neutral-200/20 hover:bg-neutral-50/50 hover:shadow-none shadow-xs text-neutral-800/80 border border-neutral-300/80 shadow-neutral-300/20 focus:ring-4 hover:border-neutral-600/40 focus:ring-neutral-100/70 focus:border-neutral-300/90 dark:bg-neutral-700/60 dark:border-neutral-500/30 dark:shadow-neutral-950/40 dark:hover:bg-neutral-800/90 dark:focus:ring-neutral-700/80 dark:focus:border-neutral-500/80"
      when "transparent"
        "bg-transparent text-neutral-700 focus:ring-neutral-100/70 hover:bg-neutral-50/70 hover:text-neutral-800 dark:focus:ring-neutral-600/80 dark:hover:bg-neutral-900 focus:outline focus:outline-neutral-200/80 dark:focus:outline-neutral-700/80 dark:text-neutral-200"
      when "black"
        "bg-neutral-950 text-neutral-100 focus:ring-neutral-100/70 hover:text-neutral-50 hover:ring-4 hover:ring-black/10 focus:outline focus:outline-neutral-200/80 dark:focus:outline-neutral-700/80 dark:bg-neutral-50 dark:text-neutral-950 dark:hover:bg-neutral-100/80 dark:hover:text-neutral-950 dark:focus:ring-neutral-700/30"
      end

      [base_classes, size_classes, variant_classes].join(" ")
    end


    def snippet_classes(variant: "active")
      case variant_classes = variant
      when "active"
        "bg-white px-3 py-1.5 rounded-md shadow flex items-center justify-center gap-2 text-[13px] font-semibold focus:ring-4 focus:ring-blue-600 group dark:bg-neutral-800/90 dark:text-neutral-100 dark:focus:ring-blue-600/50 dark:text-neutral-300"
      when "inactive"
        "bg-transparent px-3 py-1.5 rounded-md shadow-none flex items-center justify-center gap-2 text-[13px] font-semibold dark:text-neutral-300"
      end
    end

  end
end
