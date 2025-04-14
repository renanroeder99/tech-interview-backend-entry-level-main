class RemoveAbandonedCartsJob
	include Sidekiq::Job

	def perform
		Cart.where("updated_at <= ?", 7.days.ago).where(abandoned: true).find_each(&:destroy!)
	end
end