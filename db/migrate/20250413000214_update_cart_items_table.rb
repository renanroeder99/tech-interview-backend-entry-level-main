class UpdateCartItemsTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :cart_items, :cart
    remove_column :cart_items, :product

    add_column :cart_items, :cart_id, :integer, null: false
    add_column :cart_items, :product_id, :integer, null: false
    add_column :cart_items, :product_name, :string, null: false
    add_column :cart_items, :unit_price, :decimal, precision: 17, scale: 2, null: false

    add_check_constraint :cart_items, 'quantity > 0', name: 'positive_quantity'
    add_check_constraint :cart_items, 'unit_price > 0', name: 'positive_price'
    add_check_constraint :cart_items, "product_name IS NOT NULL AND product_name <> ''", name: 'valid_product_names'
  end
end
