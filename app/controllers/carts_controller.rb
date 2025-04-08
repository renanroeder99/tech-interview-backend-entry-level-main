class CartsController < ApplicationController
  before_action :initialize_cart_service
  delegate  :load_cart_from_session,
            :add_product,
            :save_current_cart_to_session,
            :build_cart_json,
            to: :@cart_service


  def show
    puts session[:cart]
    if session[:cart].nil?
      return render json: { :message => 'Cart Empty' }, status: :ok
    end

    load_cart_from_session
    render json: build_cart_json, status: :ok
  end

  def create
    cart = Cart.new(cart_params)
    cart.last_interaction_at(Time.now)
  end

  def add_item
    load_cart_from_session
    add_product(cart_params[:product_id], cart_params[:quantity].to_i) if validate_payload
    save_current_cart_to_session
  end

  private
  def initialize_cart_service
    session[:cart_id] ||= SecureRandom.uuid
    @cart = Cart.find_or_initialize_by(id: session[:cart_id])
    @cart.cart_products = []
    @cart_service = CartService.new(@cart, session)
  end

  def cart_params
    params.permit(:product_id, :product_name, :unit_price, :total_price, :quantity)
  end

  def validate_payload
    cart_params[:product_id].present? && cart_params[:quantity].present?
  end
end