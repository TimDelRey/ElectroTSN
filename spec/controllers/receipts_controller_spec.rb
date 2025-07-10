require 'rails_helper'

RSpec.describe "Receipts", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/receipts/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/receipts/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /download" do
    it "returns http success" do
      get "/receipts/download"
      expect(response).to have_http_status(:success)
    end
  end

end
