require 'rails_helper'

RSpec.describe "/carts", type: :request do

  describe "DELETE /#{:product_id}" do
    let(:cart) { Cart.create!(total_price: 0.0) }
    let(:product) { Product.create!(name: "Test Product", price: 10.0) }
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    context 'when the product is in the cart' do

      it 'remove product from the cart' do
        expect { delete "/cart/#{product.id}", as: :json }.
          to change { cart_item.reload }.from(cart_item).to(nil)
      end
    end
  end

  describe "POST /add_items" do
    let(:cart) { Cart.create!(total_price: 0.0) }
    let(:product) { Product.create!(name: "Test Product", price: 10.0) }
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    context 'validade persistence and association' do
      subject do
        :cart.save!
        expect(cart.persisted?).to be true
        :product.save!
        expect(product.persisted?).to be true
        :cart_item.save!
        expect(cart_item.persisted?).to be true

        expect(cart.cart_items).to include(cart_item)
        expect(cart_item.product).to eq(product)
      end
    end

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end

      it 'updates total value of product' do
        expect { subject }.to change { cart_item.reload.total_price }.by(20.0)
      end
    end

    context 'when adding a product to cart' do
      subject do
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates total value of cart' do
        expect { subject }.to change { cart.reload.total_price }.by(10.0)
      end
    end
  end
end
