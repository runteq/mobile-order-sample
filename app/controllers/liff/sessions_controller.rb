module Liff
  class SessionsController < BaseController
    skip_before_action :verify_authenticity_token, only: [ :create ]

    def create
      line_user_id = params[:line_user_id]
      display_name = params[:display_name]

      if line_user_id.blank?
        render json: { error: "line_user_id is required" }, status: :bad_request
        return
      end

      user = User.find_or_create_by!(line_user_id: line_user_id) do |u|
        u.display_name = display_name
      end

      user.update(display_name: display_name) if display_name.present? && user.display_name != display_name

      # Store both user_id and line_user_id for redundancy
      session[:user_id] = user.id
      session[:line_user_id] = line_user_id

      render json: { success: true, user_id: user.id }
    end
  end
end
