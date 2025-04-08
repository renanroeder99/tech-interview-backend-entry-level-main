FactoryBot.define do
	factory :shopping_cart, class: 'Cart' do

		last_interaction_at { Time.current }
		cart_products = [
			{
				"id": 1,
				"name": "Samsung Galaxy S24 Ultra",
				"price": "12999.99",
				"created_at": "2025-04-06T03:49:30.078Z",
				"updated_at": "2025-04-06T03:49:30.078Z"
			},
			{
				"id": 2,
				"name": "iPhone 15 Pro Max",
				"price": "14999.99",
				"created_at": "2025-04-06T03:49:30.089Z",
				"updated_at": "2025-04-06T03:49:30.089Z"
			},
			{
				"id": 3,
				"name": "Xiamo Mi 27 Pro Plus Master Ultra",
				"price": "999.99",
				"created_at": "2025-04-06T03:49:30.097Z",
				"updated_at": "2025-04-06T03:49:30.097Z"
			},
		]

		trait :abandoned do
			last_interaction_at { 3.hours.ago }
		end

		trait :long_abandoned do
			last_interaction_at { 7.days.ago }
		end
	end
end