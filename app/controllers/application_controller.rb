class ApplicationController < ActionController::API
	rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
	rescue_from ActionController::ParameterMissing, with: :parameter_missing
	rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
	rescue_from ActionController::RoutingError, with: :routing_error
	rescue_from ArgumentError, with: :argument_error

	def record_not_found(exception)
		puts "exception #{exception.model}"
		case exception.model
			when 'Product'
				build_exception_json handled_message: 'Product not found',
				                     exception: exception.message,
				                     status: :not_found

			when 'Cart'
				build_exception_json handled_message: 'Cart not found',
				                     exception: exception.message,
				                     status: :not_found
			else
				build_exception_json handled_message: 'NOT FOUND!',
				                     exception: exception.message,
				                     status: :not_found
		end
	end

	def parameter_missing(exception)
		case exception.model
			when 'Product'
				build_exception_json handled_message: 'Parameter not found for Product',
				                     exception: exception.message,
				                     status: :unprocessable_entity

			when 'Cart'
				build_exception_json handled_message: 'Parameter not found for Cart',
				                     exception: exception.message,
				                     status: :unprocessable_entity
			else
				build_exception_json handled_message: 'Parameter not found',
				                     exception: exception.message,
				                     status: :unprocessable_entity

		end
	end

	def record_invalid(exception)
		build_exception_json handled_message: 'Invalid record',
		                     exception: exception.message,
		                     status: :unprocessable_entity
	end

	def routing_error(exception)
		build_exception_json handled_message: 'Route not found',
		                     exception: exception.message,
		                     status: :not_found
	end

	def argument_error(exception)
		build_exception_json handled_message: 'Argument error',
		                     exception: exception.message,
		                     status: :unprocessable_entity
	end

	def build_exception_json(handled_message:, exception:, status:)
		render json: {
			error: status,
			message: handled_message,
			exception_message: exception
		}, status: status
	end
end
