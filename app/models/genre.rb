class Genre < ActiveRecord::Base

	acts_as_list
	
	has_many :categories,			dependent: :destroy
	has_many :topics,				through: :categories

	accepts_nested_attributes_for 	:categories

	validates :description, 		presence: true, length: { maximum: 25 },
									uniqueness: { case_sensitive: false }

	validates :created_by,			presence: true, 
									numericality: { greater_than: 0, 
													allow_nil: false,
													only_integer: true }

	validates :status,				presence: true,
									numericality: { range: 1..3,
													only_integer: true }

	
	def self.with_topics
		self.where('genres.status = 1')
			.joins(:topics)
			.merge(Topic.approved)
			.having('topics.count >0')
			.group('genres.id')
			.order('position')
	end

end
