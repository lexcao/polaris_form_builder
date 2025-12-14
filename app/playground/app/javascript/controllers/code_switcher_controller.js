import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="code-switcher"
export default class extends Controller {
  static targets = ["tab", "code"]

  switch(event) {
    const selected = event.currentTarget.dataset.codeTab

    // Toggle tab styles
    this.tabTargets.forEach((tab) => {
      const active = tab.dataset.codeTab === selected
      tab.setAttribute("color", active ? "strong" : "subdued")
    })

    // Toggle code blocks
    this.codeTargets.forEach((block) => {
      block.hidden = block.dataset.codeContent !== selected
    })
  }
}
