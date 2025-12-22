// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers"
import "@hotwired/turbo-rails"

if (new URLSearchParams(window.location.search).has("debug_turbo")) {
  const log = (...args) => console.log("[turbo-debug]", ...args)

  const events = [
    "turbo:click",
    "turbo:before-visit",
    "turbo:visit",
    "turbo:before-fetch-request",
    "turbo:before-fetch-response",
    "turbo:before-cache",
    "turbo:before-render",
    "turbo:render",
    "turbo:load",
  ]

  for (const eventName of events) {
    document.addEventListener(eventName, (event) => {
      const detail = event?.detail || {}
      const url = detail.url?.toString?.() || detail.url || null

      log(eventName, {
        url,
        action: detail.action,
        fetchOptions: detail.fetchOptions,
        responseStatus: detail.fetchResponse?.response?.status,
      })
    })
  }
}
