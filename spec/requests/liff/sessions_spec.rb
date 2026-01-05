require 'rails_helper'

RSpec.describe "Liff::Sessions", type: :request do
  describe "POST /liff/session" do
    it "creates a new user and returns success" do
      expect {
        post liff_session_path, params: { line_user_id: "U123456" }, as: :json
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["success"]).to be true
    end

    it "uses existing user if line_user_id already exists" do
      existing_user = create(:user, line_user_id: "U123456")

      expect {
        post liff_session_path, params: { line_user_id: "U123456" }, as: :json
      }.not_to change(User, :count)

      json = JSON.parse(response.body)
      expect(json["user_id"]).to eq(existing_user.id)
    end
  end
end
