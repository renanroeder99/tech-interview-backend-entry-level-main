class CartsController < ApplicationController
  before_action :validate_payload, :initialize_cart_service
  delegate  :load_cart,
            :add_product,
            :remove_product,
            :save_current_cart_to_session,
            :build_cart_json,
            to: :@cart_service


  def show
    render json: build_cart_json, status: :ok
  end

  def create
    add_product params[:product_id], params[:quantity].to_i
    @cart.save!
    render json: build_cart_json, status: :ok
  end

  def add_item
    add_product cart_params[:product_id], cart_params[:quantity].to_i
    @cart.save!
    render json: build_cart_json, status: :ok
  end

  def remove_item
    remove_product product_id: cart_params[:product_id]
    @cart.save!
    render json: build_cart_json, status: :ok
  end

  private
  def initialize_cart_service
    session[:cart_id] ||= SecureRandom.uuid
    @cart = Cart.find_or_initialize_by(id: session[:cart_id])
    if @cart.new_record? and @cart.id != 0
      @cart.total_price = 0.0
      @cart.save!
    end
    @cart_service = CartService.new(@cart, session)
  end

  def cart_params
    params.permit(:product_id, :product_name, :unit_price, :total_price, :quantity)
  end

  def validate_payload
    cart_params[:product_id].present? && cart_params[:quantity].present?
  end
end