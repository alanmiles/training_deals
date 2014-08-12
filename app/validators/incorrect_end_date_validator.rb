class IncorrectEndDateValidator < ActiveModel::EachValidator
	def validate_each(record, attribute, value)
		unless record.start_date.nil? || record.end_date.nil?
			if record.end_date < record.start_date
				record.errors[attribute] << "must not be before start date."
			end
		end
	end
end