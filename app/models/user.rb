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
	
	validates :password,	presence: { on: :create }, length: { minimum: 6 }
	validates :latitude,	presence: true

	def User.new_remember_token
		begin
			tkn = SecureRandom.urlsafe_base64
		end while User.exists?(remember_token: tkn)
		tkn
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

	def self.search(search)
		if search
			where('name ILIKE ? or city ILIKE ? or country ILIKE ? or email ILIKE ?', 
				"%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
		else
			all
		end
	end

	def send_password_reset
	  	self.password_reset_token = User.new_remember_token
	  	self.password_reset_sent_at = Time.zone.now
	  	save!(:validate => false)
	  	UserMailer.password_reset(self).deliver
	end

	private

		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end
	
end
