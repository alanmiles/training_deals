FactoryGirl.define do
	factory :user do
		sequence(:name)		{ |n| "person #{n}" }
		sequence(:email)	{ |n| "person_#{n}@example.com" }
		password "foobar"
		password_confirmation "foobar"

		factory :admin do
			admin true
		end
	end

	factory :training_method do
		description "On-line"
	end

	factory :duration do
		time_unit 	"Minute"
	end

	factory :content_length do
		description "Module"
	end

	factory :genre do
		description "College"
		status 2
	end

	factory :category do
		sequence(:description)		{ |n| "Category_#{n}" }
		status 2
		genre
	end

	factory :topic do
		sequence(:description)			{ |n| "Topic_#{n}" }
		status 2
		category
	end

	factory :business do
		sequence(:name)					{ |n| "Business_#{n}" }
		description	"Simply the best"
		street_address "23 Pembroke Street"
		city "Salford"
		state "Greater Manchester"
		postal_code "M6 5GS"
		country "United Kingdom"
		latitude 53.482616
		longitude -2.296699
		sequence(:email)				{ |n| "business_#{n}@example.com" }
		created_by 1		
	end

	factory :ownership do
		business
		user
		email_address "person_1@example.com"		
		created_by 1
	end

	factory :product do
		business
		sequence(:title)				{ |n| "Product_#{n}" }
		#ref_code "AAA/0001"
		topic
		training_method
		content_number 5
		content_length
		currency "GBP"
		standard_cost 100.00
		content "Course content"
		outcome "Course outcome"
		created_by 1
	end			
end