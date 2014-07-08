class Business < ActiveRecord::Base

	before_save						:capitalize_city

	validates :name, 				presence: true, length: { maximum: 75 },
									uniqueness: { scope: [:country, :city], case_sensitive: false }

	validates :country, 			presence: true, length: { maximum: 50 }
	validates :postalcode, 			length: { maximum: 15 }
	validates :region, 				length: { maximum: 50 }
	validates :city, 				presence: true, length: { maximum: 25 }
	validates :street, 				presence: true, length: { maximum: 255 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, 				presence: true, format: { with: VALID_EMAIL_REGEX }

	validates :description, 		presence: true, length: { maximum: 140 }

	validates :created_by,			presence: true, 
									numericality: { greater_than: 0, 
													allow_nil: false,
													only_integer: true }

	def full_address
		address = [self.street, self.city]
		address.push(self.region) unless self.region.blank?
		address.push(self.postalcode) unless self.postalcode.blank?
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
end

private

	def capitalize_city
		@names = self.city.split
		@names.map!(&:capitalize)
		@valid_name = @names.join(" ")
		self.city = @valid_name
	end

