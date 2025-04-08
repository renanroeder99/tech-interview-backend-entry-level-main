class RemoveAbandonedCartsJob
	include Sidekiq::Job

	def remove_abandoned_job
		removal_time = 7.days.ago
		Cart.where("last_interaction_at <= ? AND abandoned = ?", removal_time, true).find_each do |cart|
			cart.destroy!
		end
	end
end
