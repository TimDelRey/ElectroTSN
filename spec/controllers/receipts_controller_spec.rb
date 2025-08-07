require 'rails_helper'

RSpec.describe ReceiptsController, type: :controller do
  routes { Rails.application.routes }

  describe "GET /download" do
    before do
      allow(controller).to receive(:authenticate_user!)
    end

    context 'when receipt has url to s3' do
      it "redirects to the attached file URL when present" do
        receipt = create(:receipt)
        file = fixture_file_upload("test_file.xls", "application/vnd.ms-excel")
        receipt.xls_file.attach(file)

        get :download, params: { id: receipt.id }

        expect(response).to redirect_to(rails_blob_url(receipt.xls_file, only_path: true))
      end
    end

    context 'when receipt without url to s3' do
      it "returns 404 if no file is attached" do
        receipt = create(:receipt)

        get :download, params: { id: receipt.id }

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when receipt not found' do
      it "raises ActiveRecord::RecordNotFound for missing receipt" do
        expect {
          get :download, params: { id: -1 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
