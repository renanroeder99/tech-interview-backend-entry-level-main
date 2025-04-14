class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform
    carts = Cart.where("updated_at <= ?", 3.hours.ago)
    carts.each do |cart|
      cart.mark_as_abandoned if !cart.abandoned?
      cart.save!
    end

  end


end