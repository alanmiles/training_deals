class Ownership < ActiveRecord::Base

	acts_as_list
	
	belongs_to :business
	belongs_to :user

	before_save { self.email_address = email_address.downcase }

	validates :user_id, 			presence: true,
									uniqueness: { scope: :business_id, message: "is already a team member" }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email_address, 		presence: true, format: { with: VALID_EMAIL_REGEX }
	validates :business_id,			presence: true
	validates :contactable,			inclusion: { in: [true, false] }
	validates :created_by,			presence: true,
									numericality: { greater_than: 0, 
													allow_nil: false,
													only_integer: true }

end