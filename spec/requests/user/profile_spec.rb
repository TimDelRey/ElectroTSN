require 'rails_helper'

RSpec.describe "User::Profiles", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/user/profile/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/user/profile/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/user/profile/update"
      expect(response).to have_http_status(:success)
    end
  end

end
