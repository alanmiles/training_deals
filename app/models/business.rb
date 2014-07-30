class Business < ActiveRecord::Base

	#before_save						:capitalize_locality
	geocoded_by :full_address 
	#accepts_nested_attributes_for :ownerships

	after_validation :geocode, :if => :check_address?
	after_validation :inactive_date
	after_create :new_ownership

	has_many :ownerships, dependent: :destroy
	has_many :users, through: :ownerships
	has_many :products, dependent: :destroy

	validates :name, 				presence: true, length: { maximum: 75 },
									uniqueness: { scope: [:country, :city], case_sensitive: false }
	validates :street_address, 		presence: true
	#validates :latitude,			presence: true
	#validates :longitude,			presence: true
	validates :country, 			presence: true
	validates :city,				presence: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, 				presence: true, format: { with: VALID_EMAIL_REGEX }

	validates :description, 		presence: true, length: { maximum: 140 }

	validates :created_by,			presence: true, 
									numericality: { greater_than: 0, 
													allow_nil: false,
													only_integer: true }

	def full_address
		address = [self.street_address, self.city]
		address.push(self.state) unless self.state.blank?
		address.push(self.postal_code) unless self.postal_code.blank?
		address.push(self.country)
		address.join(", ")
	end

	def all_phones_vendor
		if self.phone.blank? && self.alt_phone.blank?
			return "Not shown"
		elsif self.alt_phone.blank?
			return self.phone
		elsif self.phone.blank?
			return self.alt_phone
		else
			return "#{self.phone} / #{self.alt_phone}"
		end
	end

	def owners_list
		ownerlist = []
		@owners = self.users.order("position")
		@owners.each do |owner|
			ownerlist.push("#{owner.name} <#{owner.email}>")
		end
		ownerlist.join(", ")
	end

	def currency_code
		@country = Country.find_country_by_name(country)
		@code = @country.currency['code']
	end

	def currency_symbol
		@country = Country.find_country_by_name(country)
		@symbol = @country.currency['symbol']
	end

	def has_products?
		@count = self.products.count
		@count > 0
	end

	private

		def check_address?
			[street_address_changed?, city_changed?, state_changed?, postal_code_changed?, country_changed?].any?
		end

		def inactive_date
		if inactive_changed?
			if inactive?
				self.inactive_from = Time.now
			else
				self.inactive_from = nil
			end
		end

		def new_ownership
			@user = User.find(self.created_by)
			Ownership.create(business_id: self.id, user_id: self.created_by, 
				email_address: @user.email, created_by: self.created_by)
		end
	end
end




