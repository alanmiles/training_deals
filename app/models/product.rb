class Product < ActiveRecord::Base

	#attr_accessor :genre_id
	#attr_accessor :category_id
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
	validates :standard_cost,		presence: { message: "must be entered, even if it is 0" }
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

	def schedulable?
		@method = TrainingMethod.find(self.training_method_id)
		@method.event?
	end

	def self.schedulable
		Product.joins(:training_method).where({ "training_methods.event" => true }).order("products.title")
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
