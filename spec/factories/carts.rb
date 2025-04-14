FactoryBot.define do
	factory :product do
		name { "Test Product" }
		price { 10.0 }
	end

	factory :shopping_cart, class: 'Cart' do
		total_price { 0.0 } # Define como um valor válido
		abandoned { false } # Estado inicial não abandonado
		last_interaction_at { Time.current } # Alinha-se com a lógica de `last_interaction_at`

		product = Product.create(name: 'Samsung Galaxy S24 Ultra',
		            price: 12999.99)

		after(:create) do |cart|
			cart.cart_items = [
				CartItem.new(cart: cart, product: product, quantity: 2)
			]
		end
	end

	factory :cart_item do
		association :cart
		association :product
		quantity { 1 }
		total_price { product.price * quantity }
	end
end