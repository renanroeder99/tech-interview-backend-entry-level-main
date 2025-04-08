class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def cart_abandoned_job(id)
    abandonment_time = 3.hours.ago
    cart = Cart.find id
    return unless cart
    cart.update!(abandoned: true) if cart.last_interaction_at session <= abandonment_time
  end


end