class Category < ActiveRecord::Base

	belongs_to 	:genre
	has_many	:topics, 			dependent: :destroy
	has_many	:products,			through: :topics

	accepts_nested_attributes_for 	:topics

	validates :genre,				presence: true

	validates :description, 		presence: true, length: { maximum: 25 },
									uniqueness: { case_sensitive: false, scope: :genre_id }

	validates :created_by,			presence: true, 
									numericality: { greater_than: 0, 
													allow_nil: false,
													only_integer: true }

	validates :status,				presence: true,
									numericality: { range: 1..3,
													only_integer: true }

	def self.with_topics
		self.where('categories.status = 1')
			.joins(:topics)
			.merge(Topic.approved)
			.having('topics.count >0')
			.group('categories.id')
			.order('categories.description')
	end

	def active_products
		products.joins(:business).where("products.current =? and businesses.inactive = ?", true, false)
	end

	def classification
		genre_name = genre.description
		return genre_name + " >> " + self.description
	end
end
