namespace :db do 
	desc "Fill database with set-up data"
	task populate: :environment do
		
		make_users
		make_training_methods
		make_durations
		make_content_lengths
		make_genres
		make_categories
		make_topics
		make_businesses
		make_ownerships
	end	
end

def make_users
	@admin1 = User.create!(	name: "Alan Miles",
							email: "alanpqs@gmail.com",
							password: "foobar",
							password_confirmation: "foobar")
	@admin1.toggle!(:admin)

	@admin2 = User.create!(	name: "Edwin Miles",
							email: "edwinthemiles@gmail.com",
							password: "foobar",
							password_confirmation: "foobar")
	@admin2.toggle!(:admin)

	@admin3 = User.create!(	name: "Mike Stiff",
							email: "michael.stiff@hotmail.co.uk",
							password: "foobar",
							password_confirmation: "foobar")
	@admin3.toggle!(:admin)
end

def make_training_methods
	@path = 'public/data/training_methods.csv'
	@model = TrainingMethod
	task_details(@path, @model)
end

def make_durations
	@path = 'public/data/durations.csv'
	@model = Duration
	task_details(@path, @model)
end

def make_content_lengths
	@path = 'public/data/content_lengths.csv'
	@model = ContentLength
	task_details(@path, @model)
end

def make_genres
	@path = 'public/data/genres.csv'
	@model = Genre
	task_details(@path, @model)
end

def make_categories
	lines = File.new('public/data/genre_categories.csv').readlines
	header = lines.shift.strip
	keys = header.split(';')
	lines.each do |line|
		values = line.strip.split(';')
		genre = values[0]
		cat = values[1]
		creator = values[2]
		approved = values[3]
		@genre = Genre.find_by(description: genre)
		@attr = { description: cat, genre_id: @genre.id, created_by: creator, status: approved }
		Category.create(@attr)
	end
end

def make_topics
	lines = File.new('public/data/genre_category_topics.csv').readlines
	header = lines.shift.strip
	keys = header.split(';')
	lines.each do |line|
		values = line.strip.split(';')
		genre = values[0]
		cat = values[1]
		topic = values[2]
		creator = values[3]
		approved = values[4]
		@genre = Genre.find_by(description: genre)
		@category = Category.find_by(description: cat, genre_id: @genre.id)
		@attr = { description: topic, category_id: @category.id, created_by: creator, status: approved }
		Topic.create(@attr)
	end
end

def make_businesses
	@path = 'public/data/businesses.csv'
	@model = Business
	task_details(@path, @model)
end

def make_ownerships
	@path = 'public/data/ownerships.csv'
	@model = Ownership
	task_details(@path, @model)
end


def task_details(path, model)
	lines = File.new(path).readlines
	header = lines.shift.strip
	keys = header.split(';')
	lines.each do |line|
		params = {}
		values = line.strip.split(';')
		keys.each_with_index do |key, i|
			params[key] = values[i]
		end
		model.create(params)
	end
end




