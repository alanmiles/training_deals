class User < ActiveRecord::Base

	has_secure_password
	before_save { self.email = email.downcase }
	before_create :create_remember_token

	has_many :ownerships, dependent: :destroy
	has_many :businesses, through: :ownerships

	validates :name, 		presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, 		presence: true, format: { with: VALID_EMAIL_REGEX },
							uniqueness: { case_sensitive: false }
	
	validates :password,	length: { minimum: 6 }
	validates :latitude,	presence: true

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.digest(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def has_businesses?
		business_count = self.businesses.count
		business_count > 0
	end

	def has_one_business?
		business_count = self.businesses.count
		business_count == 1
	end

	def first_business
		@business = self.businesses.first
	end

	private

		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end
	
end
