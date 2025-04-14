class CartService
	def initialize(cart, session)
		@cart = cart
		@session = session
		puts "Cart initialized on service: #{@cart}"
		@session_cart_id = session[:cart_id]
	end

	def add_product(product_id, quantity)
		validate_quantity quantity
		@cart.save! if @cart.new_record?

		product = Product.find product_id

		cart_item = @cart.cart_items.find_or_initialize_by product: product

		cart_item.quantity ||= 0
		cart_item.quantity += quantity
		cart_item.total_price = product.price * cart_item.quantity
		cart_item.save
		update_cart_total_price
	end

	def remove_product(product_id)
		return build_cart_json unless @cart.cart_items.exists?
		item_to_remove = @cart.cart_items.find_by product_id
		if item_to_remove.present?
			item_to_remove.destroy
		else
			raise ActiveRecord::RecordNotFound.new(nil, 'Product')
		end
		update_cart_total_price
	end

	def build_cart_json
		puts "@cart.cart_items #{@cart.cart_items.inspect}"
		if @cart.cart_items.exists?
			return {
				id: @cart.id,
				products: @cart.cart_items.map { |item| format_item_for_json(item) },
				total_price: @cart.total_price || 0.0
			}

		end
		{ message: 'Cart currently empty!' }
	end

private

	def format_item_for_json(item)
		{
			id: item.product.id,
			name: item.product.name,
			quantity: item.quantity,
			unit_price: item.product.price,
			total_price: item.total_price
		}
	end

	def validate_quantity(quantity)
		raise ArgumentError, "Quantity must be greater than 0" if quantity <= 0
	end

	def update_cart_total_price
		@cart.total_price = @cart.cart_items.sum(&:total_price)
	end
end