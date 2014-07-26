class Duration < ActiveRecord::Base

	acts_as_list

	has_many :products			#no deletion if associated products
	
	validates :time_unit, 		presence: true, length: { maximum: 25 },
								uniqueness: { case_sensitive: false }


end
