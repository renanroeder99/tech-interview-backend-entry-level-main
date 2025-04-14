class Cart < ApplicationRecord

  validates_numericality_of :total_price, greater_than_or_equal_to: 0
  attr_accessor :abandoned, :last_interaction_at

  has_many :cart_items, dependent: :destroy

  after_initialize do
    self.cart_items ||= []
  end

  def abandoned?
    abandoned
  end

  def mark_as_abandoned
    self.abandoned = true if last_interaction_at && last_interaction_at <= 3.hours.ago
  end

  def remove_if_abandoned
    destroy! if abandoned? && last_interaction_at && last_interaction_at <= 7.days.ago
  end
end