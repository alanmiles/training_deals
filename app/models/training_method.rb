class TrainingMethod < ActiveRecord::Base

	validates :description, 		presence: true, length: { maximum: 25 },
									uniqueness: { case_sensitive: false }

end
