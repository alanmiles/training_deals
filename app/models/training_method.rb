class TrainingMethod < ActiveRecord::Base

	acts_as_list
	
	has_many :products		#cannot delete method if related product

	validates :description, 		presence: true, length: { maximum: 25 },
									uniqueness: { case_sensitive: false }

	def self.product_selection(products)
		self.order('position').find(products.map(&:training_method_id).uniq)
	end

end
