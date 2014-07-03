class Category < ActiveRecord::Base

	belongs_to :genre

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
end
