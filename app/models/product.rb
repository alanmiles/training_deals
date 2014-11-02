class Product < ActiveRecord::Base

	mount_uploader :image, ImageUploader

	belongs_to :business
	belongs_to :topic
	belongs_to :training_method
	belongs_to :duration
	belongs_to :content_length

	has_many	:events, dependent: :destroy

	before_create	:add_currency

	validates :business,			presence: true
	validates :topic,				presence: true
	validates :training_method,		presence: true
	validates :title,				presence: true, length: { maximum: 50 },
									uniqueness: { scope: [:business_id, :topic_id], case_sensitive: false }
	validates :ref_code,			length: { maximum: 20 }
	validates :qualification,		length: { maximum: 50 }
	validates :duration_id,			presence: true, if: lambda {|s| !s.duration_number.nil? },
									numericality: { only_integer: true, allow_nil: true }
	validates :duration_number,		presence: true, if: lambda {|s| !s.duration_id.nil? }
	validates :content_length_id,	presence: true, if: lambda {|s| !s.content_number.nil? },
									numericality: { only_integer: true, allow_nil: true }
	validates :content_number,		presence: true, if: lambda {|s| !s.content_length_id.nil? }
	#validates :currency,			presence: true
	validates :standard_cost,		presence: { message: "must be entered, even if it is 0" },
									numericality: true
	validates :content,				presence: true, length: { maximum: 125 }
	validates :outcome,				presence: true, length: { maximum: 125 }
	validates :created_by,			presence: true,
									numericality: { greater_than: 0, 
													allow_nil: false,
													only_integer: true }
	validates :web_link, 			allow_blank: true, 
		uri: { format: /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix }

	def web_link= url_str
	  unless url_str.blank?
	    unless url_str.split(':')[0] == 'http' || url_str.split(':')[0] == 'https'
	        url_str = "http://" + url_str
	    end
	  end  
	  write_attribute :web_link, url_str
	end

	def ref_code_formatted
		if ref_code?
			ref_code
		else
			"No reference code entered"
		end
	end

	def formatted_duration_number
		sprintf("%g", duration_number)
	end

	def formatted_content_number
		sprintf("%g", content_number)
	end

	def formatted_standard_price
		if standard_cost == 0
			s_price = 'FREE'
		else
			s_price = "#{business.currency_symbol} #{ActionController::Base.helpers.number_with_precision(self.standard_cost, precision: 2, delimiter: ',')}"
		end
		return s_price
	end

	def title_and_price
		title + " (#{formatted_standard_price})"
	end

	def format_details
		method = training_method.description
		unless content_length.nil?
			content = " - #{ActionController::Base.helpers.pluralize(formatted_content_number, 
				self.content_length.description.downcase)}"
		else
			content = ""
		end
		unless duration_id.nil?
			duration = " - #{ActionController::Base.helpers.pluralize(formatted_duration_number, 
				self.duration.time_unit.downcase)}"
		else
			duration = ""
		end
		return method + content + duration
	end

	def schedulable?
		if current?
			@method = TrainingMethod.find(self.training_method_id)
			@method.event?
		else
			false
		end
	end

	def self.schedulable
		Product.joins(:training_method)
			.where("training_methods.event =? and products.current =?", true, true)
			.order("products.title")
	end

	def has_future_events?
		if schedulable?
			count = events.where("start_date >= ?", Date.today).count
		else
			count = 0
		end
		count > 0
	end

	def next_future_events
		events.where("start_date >= ?", Date.today).order("start_date ASC").limit(3)
	end

	def all_future_events
		events.where("start_date >= ?", Date.today).order("start_date ASC")
	end

	def total_future_events
		events.where("start_date >= ?", Date.today).count
	end

	def self.live
		self.joins(:business).where("products.current = ? and businesses.inactive = ?", true, false)
	end

	def self.q_filter(q_filter)
		if q_filter
			where('qualification ILIKE ?', "%#{q_filter}%")
		else
			all
		end
	end

	def self.supply_filter(supply_filter)
		if supply_filter
			joins(:business).where('businesses.name ILIKE ?', "%#{supply_filter}%")
		else
			all
		end
	end

	def self.keyword_filter(keyword_filter)
		if keyword_filter
			where("title ILIKE ? OR content ILIKE ? OR outcome ILIKE ?", 
					"%#{keyword_filter}%", "%#{keyword_filter}%", "%#{keyword_filter}%")
		else
			all
		end
	end

	def self.select_by_country(country)
		joins(:business).where('businesses.country = ?', country)
	end

	def self.nearby(latitude, longitude)
		includes(:business).merge(Business.neighbourhood(latitude, longitude).references(:business))
	end

	def self.accessible(latitude, longitude)
		includes(:business).merge(Business.accessible_from(latitude, longitude).references(:business))
	end

	private

		def add_currency
			unless self.business_id.nil?
				@business = Business.find(self.business_id)
				unless @business.nil?
					self.currency = @business.currency_code 
				end
			end
		end


end
