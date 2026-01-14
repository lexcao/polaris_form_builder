// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers"
import "@hotwired/turbo-rails"

const highlightPrism = () => {
  if (!window.Prism) return

  requestAnimationFrame(() => {
    window.Prism.highlightAll()
  })
}

document.addEventListener("turbo:render", highlightPrism)
