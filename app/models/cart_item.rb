class CartItem
	attr_accessor :cart_id, :id, :name, :quantity, :unit_price, :total_price

	def initialize(cart_id: nil, id:, name:, quantity:, unit_price:)
		@cart_id = cart_id
		@id = id
		@name = name
		@quantity = quantity
		@unit_price = unit_price.to_f
		@total_price = @unit_price * @quantity
	end
end