module MyBusinessesHelper

	def priority_countries
		countries = ["United Kingdom", "United States"]
	end

	def inactive_unchecked
		return "Check the box if you no longer want users to see 
				this business and its products/services. All records will remain intact and 
				you'll be able to see them. After 6 months, HROOMPH will email you to ask 
				whether you wish to remove the business entirely."
	end

	def inactive_checked
		return "Uncheck the box if you want to reactivate this business again.  Users will be
				able to see the business and find its services/products in their searches."
	end

	def hide_address_unchecked
		return "Check the box to hide your address from other users and 
			exclude your services/products from location searches. You might want to do 
			this if, for example, you sell training books worldwide - your location 
			is irrelevant."
	end

	def hide_address_checked
		return "Uncheck the box to reveal your address to other users and make your 
			services/products available when they search by location."
	end
end
