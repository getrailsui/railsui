// Rails UI Inline Controllers
// This file registers all Rails UI Stimulus controllers inline for CDN usage

(function() {
  const application = Stimulus.Application.start()
  window.Stimulus = application

  const hljs = window.hljs
  const { useTransition, useClickOutside } = window.StimulusUse || {}

  // <%= File.read(Rails.root.join('app/javascript/controllers/index.js')) %>
})()
