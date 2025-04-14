class AddProductNameToCartItems < ActiveRecord::Migration[7.1]
  def change
    add_column :cart_items, :name, :string, null: false
    add_column :cart_items, :price, :decimal, precision: 17, scale: 2
  end
end
