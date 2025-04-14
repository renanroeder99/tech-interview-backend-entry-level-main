class CreateCartItems < ActiveRecord::Migration[7.1]
  def change
    create_table :cart_items do |t|
      t.string :cart
      t.string :product
      t.integer :quantity
      t.decimal :total_price

      t.timestamps
    end
  end
end
