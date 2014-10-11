class Visitor < ActiveRecord::Base

	geocoded_by :ip_address
	after_validation :geocode 

	validates :ip_address, presence: true, uniqueness: true,
            :format => { :with => Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex), 
            :message => "Sorry, we can't identify your home area. It'll work if you sign in."}

    def self.find_or_create_by(ip, country)
    	visitor = Visitor.find_by ip_address: "#{ip}" 
    	if visitor.nil?
    		visitor = Visitor.create(ip_address: "#{ip}", country: "#{country}")
    	end
    end
end
