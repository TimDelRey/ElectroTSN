class CreateReceipts < ActiveRecord::Migration[8.0]
  def change
    create_table :receipts do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :signed
      t.date :for_month

      t.timestamps
    end
  end
end
