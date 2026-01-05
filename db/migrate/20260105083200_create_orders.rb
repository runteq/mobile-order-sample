class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.integer :total_price_cents, null: false, default: 0
      t.datetime :pickup_at
      t.text :note

      t.timestamps
    end
  end
end
