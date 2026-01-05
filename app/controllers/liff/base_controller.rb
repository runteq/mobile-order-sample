module Liff
  class BaseController < ApplicationController
    layout "liff"

    helper_method :current_user, :cart, :cart_count

    private

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = User.find_by(id: session[:user_id])
    end

    def require_liff_user
      unless current_user
        render "liff/shared/require_login", status: :unauthorized
      end
    end

    def cart
      session[:cart] ||= {}
    end

    def cart_count
      cart.values.sum
    end

    def clear_cart
      session[:cart] = {}
    end
  end
end
