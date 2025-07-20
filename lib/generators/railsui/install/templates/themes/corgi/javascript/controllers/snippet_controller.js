import { Controller } from "@hotwired/stimulus"
import hljs from "highlight.js"

export default class extends Controller {
  static targets = [
    "code",
    "language",
    "copyButton",
    "collapseButton",
    "wrapButton",
  ]
  static values = {
    language: String,
    collapsed: { type: Boolean, default: false },
    wrapped: { type: Boolean, default: false },
    code: String
  }

  connect() {
    this.initializeHighlighting()
    this.setupEventListeners()
    this.updateUI()
  }

  initializeHighlighting() {
    const codeElement = this.codeTarget
    
    // Use data attribute if available, otherwise process template content
    let text = this.codeValue || codeElement.textContent
    
    // Convert HTML entities to actual characters if from data attribute
    if (this.codeValue) {
      text = text.replace(/&#10;/g, '\n').replace(/&quot;/g, '"').replace(/&amp;/g, '&')
    } else {
      // Smart dedent for template content
      text = text.trim()
      
      if (text) {
        const lines = text.split('\n')
        const nonEmptyLines = lines.filter(line => line.trim().length > 0)
        
        if (nonEmptyLines.length > 0) {
          const indents = nonEmptyLines.map(line => line.match(/^(\s*)/)[0].length)
          const minIndent = Math.min(...indents)
          
          // Check if we have the "broken template" pattern:
          // First line has min indent, but others have excessive indent
          if (minIndent === 0 && indents.some(indent => indent > 4)) {
            // Apply language-specific smart formatting
            const language = this.languageValue || this.detectLanguage()
            if (language === 'ruby') {
              text = this.fixRubyIndentation(lines)
            } else {
              text = this.fixGenericIndentation(lines)
            }
          } else {
            // Standard dedent - remove common indentation
            const dedentedLines = lines.map(line => {
              if (line.trim().length === 0) return ''
              return line.slice(minIndent)
            })
            text = dedentedLines.join('\n')
          }
        }
      }
    }
    
    codeElement.textContent = text
    
    const language = this.languageValue || this.detectLanguage()
    
    if (language) {
      this.languageTarget.textContent = language
      codeElement.className = `language-${language}`
    }
    
    hljs.highlightElement(codeElement)
  }


  fixGenericIndentation(lines) {
    // Simple approach: just trim all lines and apply standard 2-space indentation
    // based on brace/bracket nesting for JavaScript, etc.
    const result = []
    let indentLevel = 0
    
    for (const line of lines) {
      const trimmed = line.trim()
      
      if (trimmed === '') {
        result.push('')
        continue
      }
      
      // Decrease indent for closing braces/brackets
      if (/^[}\])];?\s*$/.test(trimmed) || trimmed.startsWith('}') || trimmed.startsWith(']') || trimmed.startsWith(')')){
        indentLevel = Math.max(0, indentLevel - 1)
      }
      
      // Add current line with proper indentation
      result.push('  '.repeat(indentLevel) + trimmed)
      
      // Increase indent for opening braces/brackets or control structures
      if (trimmed.endsWith('{') || trimmed.endsWith('[') || trimmed.endsWith('(') ||
          /^(if|else|for|while|function|class)\b.*[^{]*$/.test(trimmed)) {
        indentLevel++
      }
    }
    
    return result.join('\n')
  }

  fixRubyIndentation(lines) {
    const result = []
    let indentLevel = 0
    
    for (const line of lines) {
      const trimmed = line.trim()
      
      if (trimmed === '') {
        result.push('')
        continue
      }
      
      // Decrease indent for end/else/elsif/rescue/ensure
      if (/^(end|else|elsif|rescue|ensure|when)\b/.test(trimmed)) {
        indentLevel = Math.max(0, indentLevel - 1)
      }
      
      // Add current line with proper indentation
      result.push('  '.repeat(indentLevel) + trimmed)
      
      // Increase indent for def/if/class/module/begin/case etc
      if (/^(def|if|unless|while|until|for|class|module|begin|case)\b/.test(trimmed) ||
          trimmed.endsWith(' do')) {
        indentLevel++
      }
    }
    
    return result.join('\n')
  }

  detectLanguage() {
    const codeContent = this.codeTarget.textContent
    const result = hljs.highlightAuto(codeContent)
    return result.language || "text"
  }

  setupEventListeners() {
    // Copy functionality
    this.copyButtonTarget.addEventListener("click", this.copy.bind(this))

    // Collapse functionality
    this.collapseButtonTarget.addEventListener(
      "click",
      this.toggleCollapse.bind(this)
    )

    // Wrap functionality
    this.wrapButtonTarget.addEventListener("click", this.toggleWrap.bind(this))
  }

  copy() {
    const codeText = this.codeTarget.textContent
    navigator.clipboard
      .writeText(codeText)
      .then(() => {
        // Visual feedback
        const originalText =
          this.copyButtonTarget.querySelector("span").textContent
        this.copyButtonTarget.querySelector("span").textContent = "Copied!"

        setTimeout(() => {
          this.copyButtonTarget.querySelector("span").textContent = originalText
        }, 2000)
      })
      .catch((err) => {
        console.error("Failed to copy code:", err)
      })
  }

  toggleCollapse() {
    this.collapsedValue = !this.collapsedValue
    this.updateUI()
  }

  toggleWrap() {
    this.wrappedValue = !this.wrappedValue
    this.updateUI()
  }

  updateUI() {
    const codeContainer = this.codeTarget.parentElement

    // Update collapse state
    if (this.collapsedValue) {
      codeContainer.style.maxHeight = "100px"
      codeContainer.style.overflow = "hidden"
      this.collapseButtonTarget.querySelector("span").textContent = "Expand"
    } else {
      codeContainer.style.maxHeight = "none"
      codeContainer.style.overflow = "auto"
      this.collapseButtonTarget.querySelector("span").textContent = "Collapse"
    }

    // Update wrap state
    if (this.wrappedValue) {
      this.codeTarget.style.whiteSpace = "pre-wrap"
      this.wrapButtonTarget.querySelector("span").textContent = "No Wrap"
    } else {
      this.codeTarget.style.whiteSpace = "pre"
      this.wrapButtonTarget.querySelector("span").textContent = "Wrap"
    }
  }

  collapsedValueChanged() {
    this.updateUI()
  }

  wrappedValueChanged() {
    this.updateUI()
  }
}
