module ProductsHelper

	def current_checked
		return "Uncheck the box if this product/service is no longer available.  Its history
			will remain intact, but it will no longer appear in HROOMPH listings or user searches."
	end

	def current_unchecked
		return "Check the box if you want to re-activate this product/service.  It will once
			again appear in the HROOMPH listings and user searches."
	end

end
