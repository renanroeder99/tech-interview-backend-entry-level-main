class UpdateCartItemsTableAttr < ActiveRecord::Migration[7.1]
  def change
    remove_column :cart_items, :cart_id
    remove_column :cart_items, :product_id
    remove_column :cart_items, :product_name
    remove_column :cart_items, :unit_price

    add_reference  :cart_items, :cart, null: false, foreign_key: true
    add_reference  :cart_items, :product, null: false, foreign_key: true
  end
end
