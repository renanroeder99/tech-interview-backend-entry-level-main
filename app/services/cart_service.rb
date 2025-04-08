class CartService
	def initialize(cart, session)
		@cart = cart
		@session = session
		@cart_products = []
	end

	def load_cart_from_session
		@session[:cart]&.each do |product|
			@cart_products << product.transform_keys(&:to_sym)
		end
		@cart.cart_products = @cart_products
		update_cart_total_price
	end

	def save_current_cart_to_session
		update_cart_total_price
		return if @cart_products.empty?
		@session[:cart] = @cart_products.map do |product|
			product.transform_keys(&:to_sym)
		end
	end

	def add_product(id, quantity)
		validate_quantity(quantity)
		product = product_info(id)

		existing_product = find_existing_product_in_cart(id)
		if existing_product
			update_existing_product(existing_product, quantity)
		else
			add_new_product(product, quantity)
		end
	end

	def build_cart_json
		{
			id: @cart.id,
			products: @cart_products.map { |product| format_product_for_json(product) },
			total_price: @cart.total_price || 0.0
		}
	end

private

	def find_existing_product_in_cart(id)
		@cart_products.find { |product| product[:id] == id }
	end

	def add_new_product(product, quantity)
		product[:quantity] = quantity
		product[:total_price] = calculate_total_price(product[:price].to_f, quantity.to_f)
		@cart_products << product.transform_keys(&:to_sym)
	end

	def update_existing_product(product, quantity)
		product[:quantity] += quantity
		product[:total_price] = calculate_total_price(product[:price].to_f, product[:quantity].to_f)
	end

	def serialize_cart_product(product)
		{
			id: product[:id],
			name: product[:name],
			quantity: product[:quantity],
			price: product[:price],
			total_price: product[:total_price]
		}
	end

	def format_product_for_json(product)
		{
			id: product[:id],
			name: product[:name],
			quantity: product[:quantity],
			unit_price: product[:price],
			total_price: product[:total_price]
		}
	end

	def validate_quantity(quantity)
		raise ArgumentError, "Quantity must be greater than 0" if quantity <= 0
	end

	def product_info(id)
		product = Product.find_by(id: id)
		raise ActiveRecord::RecordNotFound, "Product with ID #{id} not found" unless product

		{
			id: product.id,
			name: product.name,
			price: product.price,
			quantity: 0,
			total_price: 0.0
		}

	end

	def calculate_total_price(price, quantity)
		price * quantity
	end

	def update_cart_total_price
		@cart.total_price = @cart_products.sum do |product|
			product[:total_price] || 0.0
		end
	end
end