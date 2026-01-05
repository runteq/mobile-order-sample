module Liff
  class BaseController < ApplicationController
    layout "liff"

    helper_method :current_user, :cart, :cart_count

    private

    def current_user
      return @current_user if defined?(@current_user)

      # Try finding by user_id first
      @current_user = User.find_by(id: session[:user_id])

      # Fallback to line_user_id in session
      if @current_user.nil? && session[:line_user_id].present?
        @current_user = User.find_by(line_user_id: session[:line_user_id])
        session[:user_id] = @current_user.id if @current_user
      end

      # Final fallback: check line_user_id cookie (set by JS)
      if @current_user.nil? && cookies[:line_user_id].present?
        line_user_id = cookies[:line_user_id]
        @current_user = User.find_or_create_by!(line_user_id: line_user_id)
        session[:user_id] = @current_user.id
        session[:line_user_id] = line_user_id
      end

      @current_user
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
