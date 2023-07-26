class CreateDonations < ActiveRecord::Migration[6.1]
  def change
    create_table :donations do |t|
      t.decimal :amount
      t.string :currency
      t.string :description
      t.references :user, foreign_key: true
      t.references :payment, foreign_key: true
      t.integer :status
      t.datetime :deleted_at
      t.string :instructions
      t.timestamps
    end

      add_index :donations, :created_at
  end
end
