class Product < ActiveRecord::Base

	belongs_to :business
	belongs_to :topic
	belongs_to :training_method
	belongs_to :duration
	belongs_to :contact_length

	before_create	:add_currency

	validates :business,			presence: true
	validates :topic,				presence: true
	validates :training_method,		presence: true
	validates :title,				presence: true, length: { maximum: 75 },
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
	validates :content,				presence: true, length: { maximum: 140 }
	validates :outcome,				presence: true, length: { maximum: 140 }
	validates :created_by,			presence: true,
									numericality: { greater_than: 0, 
													allow_nil: false,
													only_integer: true }


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
