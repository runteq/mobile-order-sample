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

      // Try multiple methods to get user info
      let lineUserId = null
      let displayName = null

      // Method 1: Try getProfile (requires profile scope)
      try {
        const profile = await liff.getProfile()
        lineUserId = profile.userId
        displayName = profile.displayName
      } catch (profileError) {
        console.warn("getProfile failed:", profileError.message)

        // Method 2: Try getDecodedIDToken (requires openid scope)
        try {
          const idToken = liff.getDecodedIDToken()
          if (idToken) {
            lineUserId = idToken.sub
            displayName = idToken.name || "LINE User"
          }
        } catch (tokenError) {
          console.warn("getDecodedIDToken failed:", tokenError.message)
        }

        // Method 3: Use context as last resort
        if (!lineUserId) {
          try {
            const context = liff.getContext()
            if (context && context.userId) {
              lineUserId = context.userId
              displayName = "LINE User"
            }
          } catch (contextError) {
            console.warn("getContext failed:", contextError.message)
          }
        }
      }

      if (!lineUserId) {
        throw new Error("Could not get LINE user ID")
      }

      await this.createSession(lineUserId, displayName)
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
      // Also set line_user_id in a cookie directly (backup for session issues)
      document.cookie = `line_user_id=${encodeURIComponent(lineUserId)}; path=/; SameSite=None; Secure`

      const response = await fetch("/liff/session", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        credentials: "include",
        body: JSON.stringify({
          line_user_id: lineUserId,
          display_name: displayName
        })
      })

      if (!response.ok) {
        throw new Error(`Session creation failed: ${response.status}`)
      }

      await response.json()
      return true
    } catch (error) {
      console.error("Session error:", error)
      return false
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
