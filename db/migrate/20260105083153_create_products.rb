class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :price_cents, null: false, default: 0
      t.string :image_url
      t.boolean :is_active, null: false, default: true
      t.integer :sort_order, null: false, default: 0

      t.timestamps
    end
  end
end
