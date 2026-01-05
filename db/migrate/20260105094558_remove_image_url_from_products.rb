class RemoveImageUrlFromProducts < ActiveRecord::Migration[7.2]
  def change
    remove_column :products, :image_url, :string
  end
end
