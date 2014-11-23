class ExchangeRate < ActiveRecord::Base

	validates :currency_code, 		presence: true, length: { maximum: 3 },
									uniqueness: { case_sensitive: false }
	validates :rate,				presence: true, 
									numericality: { greater_than: 0 }

	def self.last_updated
		self.first.updated_at.strftime('%d-%b-%Y')
	end

	def self.get_latest
		require 'open-uri'
		require 'json'
		result = JSON.parse(open("http://openexchangerates.org/api/latest.json?app_id=#{Figaro.env.oer_app_id}").read)
		@rates = result["rates"]
		@rates.each do |key, value|
			@rate = self.find_by_currency_code(key)
			if @rate.nil?
				self.create(currency_code: key, rate: value)
			else
				@rate.update_attributes(rate: value)
			end
		end
	end

	def self.to_csv
		#CSV.generate do |csv|
		#	csv << column_names
		#	all.each do |xchange|
		#		csv << xchange.attributes.values_at(*column_names)
		#	end
		#end
		CSV.generate do |csv|
			csv << column_names[1..2]
			all.each do |xchange|
				csv << xchange.attributes.values_at(*column_names[1..2])
			end
		end
	end
end
