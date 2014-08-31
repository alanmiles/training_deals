class Event < ActiveRecord::Base

	serialize :start_time, Tod::TimeOfDay  #serialize allows TimeOfDay to be stored directly
	serialize :finish_time, Tod::TimeOfDay  #in a database column of the time type

	attr_accessor :weekdays

	belongs_to 	:product

	validates :product,			presence: true, product_event: true
	validates :start_date,		presence: true, uniqueness: { scope: :product_id, 
									message: "is a duplicate for this product"  }
	validates :end_date,		presence: true, incorrect_end_date: true
	validates :places_available, :places_sold,	presence: true 

	validates :places_available,	numericality: { only_integer: true, 
										greater_than_or_equal_to: 0,
										greater_than_or_equal_to: :places_sold },
									unless: Proc.new { |event| event.places_available.nil? || event.places_sold.nil? }
	validates :places_sold,		numericality: { only_integer: true, 
									greater_than_or_equal_to: 0,
									less_than_or_equal_to: :places_available },
								unless: Proc.new { |event| event.places_available.nil? || event.places_sold.nil? }	
	validates :price,			presence: { message: "must be entered, even if it is 0" },
								numericality: true
	VALID_TIME_REGEX = /([0-1]\d|2[0-3]):([0-5]\d)(:([0-5]\d))?\z/
	validates :start_time,		presence: true, if: lambda {|s| !s.finish_time.blank?},
								format: { with: VALID_TIME_REGEX, allow_blank: true }
	validates :finish_time,		presence: true, if: lambda {|s| !s.start_time.blank?},
								format: { with: VALID_TIME_REGEX, allow_blank: true }
	validates :location,		length: { maximum: 75, allow_blank: true }
	validates :note,			length: { maximum: 140, allow_blank: true }
	validates :created_by,		presence: true,
								numericality: { greater_than: 0, 
													allow_nil: false,
													only_integer: true }
	validates :time_of_day,		inclusion: { in: %w(Morning Afternoon Evening Morning/Afternoon Afternoon/Evening Varies Not\ displayed),
												allow_blank: true}

	def self.day_periods
		@period = ["Morning", "Afternoon", "Evening", "Morning/Afternoon", "Afternoon/Evening", "Varies"]
		return @period
	end

	def self.day_periods_with_blank
		@period = ["Morning", "Afternoon", "Evening", "Morning/Afternoon", "Afternoon/Evening", "Varies", "Not displayed"]
		return @period
	end

	def standard_price
		@product = Product.find(self.product_id)
		normal_price = @product.standard_cost
	end

	def savings
		result = self.standard_price - self.price
	end

	def savings_percent
		if self.price == 0
			if self.standard_price == 0
				percent = 0
			else
				percent = 100
			end
		else
			percent = self.savings / self.standard_price * 100.00
		end
	end

	def self.search(search)
		if search
			joins(:product).where('products.title ILIKE ?', "%#{search}%")
		else
			all
		end
	end

	def remaining_places
		places_available - places_sold
	end

	def has_places?
		remaining_places > 0
	end
end
