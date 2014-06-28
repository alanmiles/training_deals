namespace :db do 
	desc "Fill database with set-up data"
	task populate: :environment do
		#admin = User.create!(name: "Example User",
		#				email: "example@railstutorial.org",
		#				password: "foobar",
		#				password_confirmation: "foobar",
		#				admin: true)
		#99.times do |n|
		#	name = Faker::Name.name
		#	email = "example-#{n+1}@railstutorial.org"
		#	password = "password"
		#	User.create!(name: name,
		#				email: email,
		#				password: password,
		#				password_confirmation: password)
		#end

		make_users
		make_training_methods
		make_durations

	end	
end

def make_users
	@admin1 = User.create!(	name: "Alan Miles",
							email: "alanpqs@gmail.com",
							password: "foobar",
							password_confirmation: "foobar")
	@admin1.toggle(:admin)

	@admin2 = User.create!(	name: "Edwin Miles",
							email: "edwinthemiles@gmail.com",
							password: "foobar",
							password_confirmation: "foobar")
	@admin2.toggle(:admin)

	@admin3 = User.create!(	name: "Mike Stiff",
							email: "michael.stiff@hotmail.co.uk",
							password: "foobar",
							password_confirmation: "foobar")
	@admin3.toggle(:admin)

end

def make_training_methods
	lines = File.new('public/data/training_methods.csv').readlines
	header = lines.shift.strip
	keys = header.split(';')
	lines.each do |line|
		params = {}
		values = line.strip.split(';')
		keys.each_with_index do |key, i|
			params[key] = values[i]
		end
		TrainingMethod.create(params)
	end
end

def make_durations
	lines = File.new('public/data/durations.csv').readlines
	header = lines.shift.strip
	keys = header.split(';')
	lines.each do |line|
		params = {}
		values = line.strip.split(';')
		keys.each_with_index do |key, i|
			params[key] = values[i]
		end
		Duration.create(params)
	end
end




