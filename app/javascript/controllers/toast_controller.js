import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    duration: { type: Number, default: 2000 }
  }

  connect() {
    setTimeout(() => {
      this.element.classList.add("animate-fade-out")
      setTimeout(() => {
        this.element.remove()
      }, 300)
    }, this.durationValue)
  }
}
