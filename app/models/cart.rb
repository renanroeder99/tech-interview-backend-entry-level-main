class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0
  attr_accessor :cart_products, :abandoned, :last_interaction_at

  def initialize(attributes = {})
    super(attributes)
    self.abandoned = false
  end



  def update_interaction(session)
    session[:cart][:last_interaction_at] = Time.current
  end

  def last_interaction_at(session)
    session[:cart][:last_interaction_at]
  end


  private
  def mark_as_abandoned
    delay = [last_interaction_at(session) + 3.hours - Time.now, 0].max
    MarkCartAsAbandonedJob.perform_in(delay, id)
  end

  def remove_if_abandoned
    delay = [last_interaction_at(session) + 7.days - Time.now, 0].max
    RemoveAbandonedCartsJob.remove_abandoned_job.perform_in(delay, id)
  end
end
