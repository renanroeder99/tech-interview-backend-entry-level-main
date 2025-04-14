class CartItem < ApplicationRecord
	belongs_to :cart
	belongs_to :product

	before_save :set_total_price

	private
	def set_total_price
		self.total_price = product.price * quantity
	end
end