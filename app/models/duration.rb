class Duration < ActiveRecord::Base

	validates :time_unit, 		presence: true, length: { maximum: 25 },
								uniqueness: { case_sensitive: false }
end
