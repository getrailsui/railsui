import { Controller } from "@hotwired/stimulus"
import { marked } from "marked"
import sanitizeHtml from "sanitize-html"

export default class extends Controller {
  static targets = ["content"]

  connect() {
    this.renderMarkdown()
  }

  renderMarkdown() {
    const originalContent = this.contentTarget.innerHTML
    let content = this.contentTarget.textContent
    if (!content || !content.trim()) {
      return
    }
    content = content.trim().replace(/\r\n/g, "\n")
    content = this.dedentContent(content)
    marked.setOptions({
      breaks: true,
      gfm: true,
      sanitize: false,
      smartLists: true,
      smartypants: false,
      pedantic: false,
      silent: false,
    })
    const sanitizeOptions = {
      allowedTags: [
        "h1",
        "h2",
        "h3",
        "h4",
        "h5",
        "h6",
        "p",
        "br",
        "strong",
        "b",
        "em",
        "i",
        "u",
        "strike",
        "del",
        "ul",
        "ol",
        "li",
        "blockquote",
        "pre",
        "code",
        "a",
        "img",
        "table",
        "thead",
        "tbody",
        "tr",
        "th",
        "td",
        "div",
        "span",
        "hr",
      ],
      allowedAttributes: {
        a: ["href", "title", "target"],
        img: ["src", "alt", "title", "width", "height"],
        pre: ["class"],
        code: ["class"],
        "*": ["class", "id"],
      },
    }
    try {
      const rawHtml = marked.parse(content)
      const cleanHtml = sanitizeHtml(rawHtml, sanitizeOptions)
      this.contentTarget.innerHTML = cleanHtml
    } catch (error) {
      this.contentTarget.innerHTML = originalContent
    }
  }

  dedentContent(content) {
    const lines = content.split("\n")
    const nonEmptyLines = lines.filter((line) => line.trim().length > 0)
    if (nonEmptyLines.length === 0) return content
    const indents = nonEmptyLines.map((line) => {
      const match = line.match(/^(\s*)/)
      return match ? match[1].length : 0
    })
    let minIndent = Math.min(...indents)
    if (
      indents[0] === 0 &&
      indents.length > 1 &&
      indents.slice(1).every((indent) => indent > 0)
    ) {
      minIndent = Math.min(...indents.slice(1))
    }
    const result = lines
      .map((line, index) => {
        if (line.trim().length === 0) return ""
        if (index === 0 && indents[0] === 0) return line
        return line.slice(minIndent)
      })
      .join("\n")
    return result
  }
}
