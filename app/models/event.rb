class Event < ActiveRecord::Base

	serialize :start_time, Tod::TimeOfDay  #serialize allows TimeOfDay to be stored directly
	serialize :finish_time, Tod::TimeOfDay  #in a database column of the time type

	attr_accessor :weekdays

	belongs_to 	:product

	validates :product,			presence: true, product_event: true
	validates :start_date,		presence: true, uniqueness: { scope: :product_id, 
									message: "is a duplicate for this product"  }
	validates :end_date,		presence: true, incorrect_end_date: true
	VALID_TIME_REGEX = /([0-1]\d|2[0-3]):([0-5]\d)(:([0-5]\d))?\z/
	validates :start_time,		format: { with: VALID_TIME_REGEX, allow_blank: true }
	validates :finish_time,		format: { with: VALID_TIME_REGEX, allow_blank: true }
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
end
