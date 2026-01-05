class CreateOrderItems < ActiveRecord::Migration[7.2]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :qty, null: false, default: 1
      t.integer :unit_price_cents, null: false, default: 0

      t.timestamps
    end
    add_index :order_items, [:order_id, :product_id], unique: true
  end
end
