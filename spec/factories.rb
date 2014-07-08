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
		time_unit 	"minute"
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
		country		"United Kingdom"
		postalcode	"M6 5GS"
		city 		"Salford"
		sequence(:street)				{ |n| "#{n} Pembroke Street" }
		sequence(:email)				{ |n| "business_#{n}@example.com" }
		description	"Simply the best"
		created_by 1		
	end			
end