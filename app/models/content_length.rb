class ContentLength < ActiveRecord::Base

	acts_as_list
	
	validates :description, 		presence: true, length: { maximum: 25 },
									uniqueness: { case_sensitive: false }
end
