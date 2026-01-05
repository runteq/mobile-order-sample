# Configure session cookies
# Default Rails settings work for most cases
# LIFF handles its own session via JavaScript cookie

Rails.application.config.session_store :cookie_store,
  key: "_line_order_session"
