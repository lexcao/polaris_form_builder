import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]
  static values = { text: String }

  async copy() {
    try {
      await navigator.clipboard.writeText(this.textValue)
      this.showCopied()
    } catch (err) {
      console.error("Failed to copy:", err)
    }
  }

  showCopied() {
    const button = this.buttonTarget
    const icon = button.querySelector("i")
    const originalClass = icon.className

    icon.className = "ri-check-line"
    button.classList.add("copied")

    setTimeout(() => {
      icon.className = originalClass
      button.classList.remove("copied")
    }, 2000)
  }
}
