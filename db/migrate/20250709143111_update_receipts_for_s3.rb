class UpdateReceiptsForS3 < ActiveRecord::Migration[8.0]
  def change
    remove_column :receipts, :receipt_instance, :text

    add_column :receipts, :receipt_url, :string
    add_column :receipts, :for_month, :date
  end
end
