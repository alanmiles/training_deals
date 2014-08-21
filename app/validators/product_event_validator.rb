class ProductEventValidator < ActiveModel::EachValidator
	def validate_each(record, attribute, value)
		unless record.product_id.nil?
			@method = TrainingMethod.find(record.product.training_method.id)
			unless @method.event?
				record.errors[attribute] << "does not have an event-type format."
			end
		else
			record.errors[attribute] << "blaaahh"
		end
	end
end