class ReceiptsController < Users::BaseController
  # удалить экшн когда будет index/download_receipt всех показаний юзера
  def index
    @receipts = Receipt.signed_receipts_for_user(current_user)
    render json: @receipts
  end

  def download
    receipt = Receipt.find(params[:id])
    if receipt.xls_file.attached?
      redirect_to url_for(receipt.xls_file)
    else
      head :not_found
    end
  end
end
