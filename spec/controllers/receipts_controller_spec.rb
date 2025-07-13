require 'rails_helper'

RSpec.describe "Receipts", type: :request do
  describe "GET /download" do
    context 'when receipt has url to s3' do
      it "redirects to the attached file URL when present" do
        receipt = create(:receipt)
        file = fixture_file_upload("files/test.xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        receipt.xls_file.attach(file)

        get download_receipt_path(receipt)

        expect(response).to redirect_to(rails_blob_url(receipt.xls_file, only_path: true))
      end
    end

    context 'when receipt without url to s3' do
      it "returns 404 if no file is attached" do
        receipt = create(:receipt)

        get download_receipt_path(receipt)

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when receipt not found' do
      it "raises ActiveRecord::RecordNotFound for missing receipt" do
        expect {
          get download_receipt_path(id: -1)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

end
