import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="code-switcher"
export default class extends Controller {
  static targets = ["tab", "code"]

  switch(event) {
    const selected = event.currentTarget.dataset.codeTab

    // 切换 tab 样式
    this.tabTargets.forEach((tab) => {
      const active = tab.dataset.codeTab === selected
      tab.setAttribute("color", active ? "strong" : "subdued")
    })

    // 切换代码内容
    this.codeTargets.forEach((block) => {
      block.hidden = block.dataset.codeContent !== selected
    })
  }
}
