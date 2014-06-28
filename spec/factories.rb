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
end