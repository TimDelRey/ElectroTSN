class CreateReceipts < ActiveRecord::Migration[8.0]
  def change
    create_table :receipts do |t|
      t.integer :user_id, null: false
      t.boolean :signed, default: true
      t.text :receipt_instance

      t.timestamps
    end
  end
end
