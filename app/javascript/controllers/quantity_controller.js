import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    productId: Number,
    qty: Number
  }

  connect() {
    this.submitting = false
  }

  decrement(event) {
    event.preventDefault()
    if (this.submitting) return

    const newQty = this.qtyValue - 1
    this.submitQuantity(newQty)
  }

  increment(event) {
    event.preventDefault()
    if (this.submitting) return

    const newQty = this.qtyValue + 1
    this.submitQuantity(newQty)
  }

  async submitQuantity(qty) {
    this.submitting = true
    this.qtyValue = qty

    // Update display immediately (optimistic UI)
    const qtyDisplay = this.element.querySelector('[data-quantity-target="display"]')
    if (qtyDisplay) {
      qtyDisplay.textContent = qty
    }

    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content

    try {
      const response = await fetch(`/liff/cart_items/${this.productIdValue}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'text/vnd.turbo-stream.html',
          'X-CSRF-Token': csrfToken
        },
        credentials: 'include',
        body: `qty=${qty}`
      })

      if (response.ok) {
        const html = await response.text()
        Turbo.renderStreamMessage(html)
      }
    } catch (error) {
      console.error('Failed to update quantity:', error)
    } finally {
      this.submitting = false
    }
  }
}
