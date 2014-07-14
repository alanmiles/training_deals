class Business < ActiveRecord::Base

	#before_save						:capitalize_locality
	geocoded_by :full_address 
	after_validation :geocode, :if => :check_address?
	after_validation :inactive_date

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
	end

		

end




