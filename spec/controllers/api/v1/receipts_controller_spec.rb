require 'rails_helper'

RSpec.describe "Receipts", type: :request do
  describe "GET /download" do
    it "returns http success" do
      get "/receipts/download"
      expect(response).to have_http_status(:success)
    end
  end
end
