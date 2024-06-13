import hljs from "highlight.js"

import bash from "highlight.js/lib/languages/bash"
import javascript from "highlight.js/lib/languages/javascript"
import css from "highlight.js/lib/languages/css"
import xml from "highlight.js/lib/languages/xml"
import erb from "highlight.js/lib/languages/erb"
import haml from "highlight.js/lib/languages/haml"
import ruby from "highlight.js/lib/languages/ruby"
import scss from "highlight.js/lib/languages/scss"
import yaml from "highlight.js/lib/languages/yaml"

hljs.registerLanguage("bash", bash)
hljs.registerLanguage("css", css)
hljs.registerLanguage("javascript", javascript)
hljs.registerLanguage("xml", xml)
hljs.registerLanguage("erb", erb)
hljs.registerLanguage("haml", haml)
hljs.registerLanguage("ruby", ruby)
hljs.registerLanguage("scss", scss)
hljs.registerLanguage("yaml", yaml)

hljs.configure({
  languages: ["bash", "css", "javascript", "xml", "erb", "haml", "ruby", "scss", "yaml"]
})

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["snippet"]
  connect() {
    this.snippetTargets.forEach((el) => {
      hljs.highlightElement(el)
    })
  }
}
