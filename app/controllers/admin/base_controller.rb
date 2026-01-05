module Admin
  class BaseController < ApplicationController
    layout "admin"

    before_action :authenticate

    private

    def authenticate
      authenticate_or_request_with_http_basic("Admin") do |username, password|
        username == ENV.fetch("ADMIN_USER", "admin") &&
          password == ENV.fetch("ADMIN_PASSWORD", "password")
      end
    end
  end
end
