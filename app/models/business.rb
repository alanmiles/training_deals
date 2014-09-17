class Business < ActiveRecord::Base

	##before_save						:capitalize_locality
	#geocoded_by :full_address 
	##accepts_nested_attributes_for :ownerships

	mount_uploader :logo, LogoUploader
	mount_uploader :image, ImageUploader
	
	#after_validation :geocode, :if => :check_address?
	after_validation :inactive_date
	after_create :new_ownership

	has_many :ownerships, dependent: :destroy
	has_many :users, through: :ownerships
	has_many :products, dependent: :destroy
	has_many :events, through: :products

	validates :name, 				presence: true, length: { maximum: 75 },
									uniqueness: { scope: [:country, :city], case_sensitive: false }
	validates :street_address, 		presence: true
	validates :latitude,			presence: true
	validates :country,				presence: true
	#validates :longitude,			presence: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, 				presence: true, format: { with: VALID_EMAIL_REGEX }

	validates :description, 		presence: true, length: { maximum: 140 }

	validates :created_by,			presence: true, 
									numericality: { greater_than: 0, 
													allow_nil: false,
													only_integer: true }
	validates :website, 			allow_blank: true, 
		uri: { format: /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix }

	def website= url_str
	  unless url_str.blank?
	    unless url_str.split(':')[0] == 'http' || url_str.split(':')[0] == 'https'
	        url_str = "http://" + url_str
	    end
	  end  
	  write_attribute :website, url_str
	end

	#def full_address
	#	address = [self.street_address, self.city]
	#	address.push(self.state) unless self.state.blank?
	#	address.push(self.postal_code) unless self.postal_code.blank?
	#	address.push(self.country)
	#	address.join(", ")
	#end

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
		@ownerships = self.ownerships.order("position")
		@ownerships.each do |owner|
			if owner.contactable?
				if owner.phone?
					ownerlist.push("#{owner.user.name} <#{owner.user.email} - #{owner.phone}>")
				else
					ownerlist.push("#{owner.user.name} <#{owner.user.email}>")
				end
			else
				ownerlist.push("#{owner.user.name}")
			end
		end
		ownerlist.join(", ")
	end

	def contactable_owners_list
		ownerlist = []
		@ownerships = self.ownerships.order("position")
		@ownerships.each do |owner|
			if owner.contactable?
				if owner.phone?
					ownerlist.push("#{owner.user.name} <#{owner.user.email} - #{owner.phone}>")
				else
					ownerlist.push("#{owner.user.name} <#{owner.user.email}>")
				end
			end
		end
		ownerlist.join(", ")
	end

	def currency_code
		@country = Country.find_country_by_name(country)
		@code = @country.currency['code']
	end

	def currency_symbol
		@country = Country.find_country_by_name(country)
		#@symbol = @country.currency['symbol']
		if @country.currency['symbol'].nil?
			@symbol = self.currency_code
		else
			@symbol = @country.currency['symbol']
		end
		return @symbol
	end

	def has_products?
		@count = self.products.count
		@count > 0
	end

	def has_schedulable_products?
		@count = self.products.schedulable.count
		@count > 0
	end

	def has_events?
		@count = self.events.count
		@count > 0
	end

	def current_and_future_events
		self.events.where("events.end_date >= ?", Date.today)
	end

	def has_current_and_future_events?
		cnt = self.current_and_future_events.count
		cnt > 0
	end

	def previous_events
		self.events.where("events.end_date < ?", Date.today)
	end

	def has_previous_events?
		cnt = self.previous_events.count
		cnt > 0
	end

	def contactable_users
		self.users.joins(:ownerships).where(ownerships: { contactable: true } ).order("position")
	end

	def has_contactable_users?
		self.contactable_users.count > 0
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




