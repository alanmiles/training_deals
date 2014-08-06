class Topic < ActiveRecord::Base

	belongs_to :category
	has_many :products   #don't allow deletion of topic if related products

	validates :category,			presence: true

	validates :description, 		presence: true, length: { maximum: 50 },
									uniqueness: { case_sensitive: false, scope: :category_id }

	validates :created_by,			presence: true, 
									numericality: { greater_than: 0, 
													allow_nil: false,
													only_integer: true }

	validates :status,				presence: true,
									numericality: { range: 1..3,
													only_integer: true }

	def classification
		category_name = self.category.description
		genre_name = self.category.genre.description
		return genre_name + " >> " + category_name + " >> " + self.description
	end
end
