import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["loading", "error", "content"]

  connect() {
    this.initLiff()
  }

  async initLiff() {
    const liffId = window.LIFF_ID

    if (!liffId) {
      console.warn("LIFF_ID not configured, skipping LIFF init")
      this.showContent()
      return
    }

    try {
      await liff.init({ liffId })

      if (!liff.isLoggedIn()) {
        liff.login()
        return
      }

      const profile = await liff.getProfile()
      await this.createSession(profile.userId, profile.displayName)

      this.showContent()
    } catch (error) {
      console.error("LIFF init error:", error)

      if (liffId && !liff.isInClient()) {
        this.showError()
      } else {
        this.showContent()
      }
    }
  }

  async createSession(lineUserId, displayName) {
    try {
      const response = await fetch("/liff/session", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          line_user_id: lineUserId,
          display_name: displayName
        })
      })

      if (!response.ok) {
        throw new Error("Session creation failed")
      }

      const data = await response.json()
      console.log("Session created:", data)
    } catch (error) {
      console.error("Session error:", error)
    }
  }

  showContent() {
    if (this.hasLoadingTarget) {
      this.loadingTarget.classList.add("hidden")
    }
    if (this.hasContentTarget) {
      this.contentTarget.classList.remove("hidden")
    }
  }

  showError() {
    if (this.hasLoadingTarget) {
      this.loadingTarget.classList.add("hidden")
    }
    if (this.hasErrorTarget) {
      this.errorTarget.classList.remove("hidden")
    }
  }
}
