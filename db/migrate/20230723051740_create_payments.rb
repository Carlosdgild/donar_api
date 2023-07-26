class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.decimal :amount
      t.string :currency
      t.string :charge_id
      t.string :payment_method
      t.string :fingerprint
      t.string :card_last_number
      t.string :brand
      t.integer :status
      t.string :receipt_url
      t.json :error_info
      t.datetime :deleted_at
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
