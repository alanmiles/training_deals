include ApplicationHelper

def sign_in(user, options={})
	if options[:no_capybara]
		# Sign in when not using Capybara
		remember_token = User.new_remember_token
		cookies[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.digest(remember_token))
	else
		visit signin_path
		fill_in "Email", 	with: user.email
		fill_in "Password",		with: user.password
		click_button "Sign in"
	end
end

def valid_signin(user)
	fill_in "Email",			with: user.email 
	fill_in "Password",			with: user.password
	click_button "Sign in"
end

def valid_signup
	fill_in "Location",			with: "Tonbridge, United Kingdom"
    click_button "find"
	fill_in "Name",           	with: "Example User"
    fill_in "Email",          	with: "user@example.com"
    fill_in "Password",       	with: "foobar"
    fill_in "Confirm password", with: "foobar" 
end

def build_product_list
	let!(:founder) 			{ FactoryGirl.create(:user) }
	let!(:administrator)	{ FactoryGirl.create(:user) }
	let!(:founder_biz)		{ FactoryGirl.create(:business, created_by: founder.id)}  #founder is automatically an owner
	let!(:other_biz)		{ FactoryGirl.create(:business, created_by: founder.id)}
	let(:closed_biz)		{ FactoryGirl.create(:business, created_by: founder.id, inactive: true)}
	let!(:ownership_1)		{ FactoryGirl.create(:ownership, business: founder_biz, user: administrator,
								 email_address: administrator.email) }
	let!(:ownership_2)		{ FactoryGirl.create(:ownership, business: other_biz, user: administrator,
								 email_address: administrator.email) }
	let!(:event_method)		{ FactoryGirl.create(:training_method, description: "Seminar",
									event: true) }
	let!(:non_event_method)	{ FactoryGirl.create(:training_method, event: false) }
	let!(:length)			{ FactoryGirl.create(:content_length) }
	let!(:duration)			{ FactoryGirl.create(:duration) }
	let!(:genre_1)			{ FactoryGirl.create(:genre, status: 1) }
	let!(:genre_2)			{ FactoryGirl.create(:genre, description: 'Work', status: 1) }
	let!(:pending_genre)		{ FactoryGirl.create(:genre, description: 'Play', status: 3) }
	let!(:no_topic_genre)		{ FactoryGirl.create(:genre, description: 'Leisure', status: 1) }
	let!(:genre_1_cat_1)		{ FactoryGirl.create(:category, genre: genre_1, status: 1) }
	let!(:genre_1_cat_2)		{ FactoryGirl.create(:category, genre: genre_1, status: 1) }
	let!(:genre_1_pending_cat)	{ FactoryGirl.create(:category, genre: genre_1, status: 2) }
	let!(:genre_1_no_topic_cat)	{ FactoryGirl.create(:category, genre: genre_1, status: 1) }
	let!(:genre_2_cat_1)		{ FactoryGirl.create(:category, genre: genre_2, status: 1) }
	let!(:genre_2_cat_2)		{ FactoryGirl.create(:category, genre: genre_2, status: 1) }
	let!(:genre_1_cat_1_topic_1)	{ FactoryGirl.create(:topic, category: genre_1_cat_1, status: 1) }
	let!(:genre_1_cat_1_topic_2)	{ FactoryGirl.create(:topic, category: genre_1_cat_1, status: 1) }
	let!(:genre_1_cat_2_topic_1)	{ FactoryGirl.create(:topic, category: genre_1_cat_2, status: 1) }
	let!(:genre_2_cat_2_topic_1)	{ FactoryGirl.create(:topic, category: genre_2_cat_2, status: 1) }
	let!(:pending_topic)		{ FactoryGirl.create(:topic, category: genre_1_cat_1, status: 2 ) }

	let!(:product_1) 	{ FactoryGirl.create(:product, title: "Latest product",
				business: founder_biz,
				topic: genre_1_cat_1_topic_1, training_method: event_method, 
				content_length: nil, content_number: nil, duration_id: duration.id, duration_number: 360) }
	
	let!(:non_event_product) { FactoryGirl.create(:product, title: "Non event",
				business: founder_biz,
				topic: genre_1_cat_1_topic_1, training_method: non_event_method,
				content_length: length) }

	let!(:admin_product) 	{ FactoryGirl.create(:product, title: "Admin product",
				business: other_biz,
				topic: genre_1_cat_1_topic_1, training_method: event_method, 
				content_length: nil, content_number: nil, duration_id: duration.id, duration_number: 360) }

	let!(:delisted_product) 	{ FactoryGirl.create(:product, title: "Delisted product",
				business: founder_biz,
				topic: genre_1_cat_1_topic_1, training_method: event_method, 
				content_length: nil, content_number: nil, duration_id: duration.id, duration_number: 360,
				current: false) }

	let!(:genre2_product) 	{ FactoryGirl.create(:product, title: "Genre 2 product",
				business: other_biz,
				topic: genre_2_cat_2_topic_1, training_method: event_method, 
				content_length: nil, content_number: nil, duration_id: duration.id, duration_number: 360) }

	let!(:genre1_topic2_product) { FactoryGirl.create(:product, title: "Topic2 Product",
				business: founder_biz,
				topic: genre_1_cat_2_topic_1, training_method: non_event_method,
				content_length: length) }

	let!(:closed_biz_product) 	{ FactoryGirl.create(:product, title: "Closed biz product",
				business: closed_biz,
				topic: genre_1_cat_1_topic_1, training_method: event_method, 
				content_length: nil, content_number: nil, duration_id: duration.id, duration_number: 360) }


end

Rspec::Matchers.define :have_error_message do |message|
	match do |page|
		expect(page).to have_selector('div.alert.alert-error', text: message)
	end
end

def check_admin_menu
	specify do
		expect(page).to have_link('Admin home page', href: admin_menu_path)
		expect(page).to have_link('Framework', href: framework_path)
	end
end

def non_admin_illegal_get(title)
	specify { expect(response.body).not_to match(full_title(title)) }
	specify { expect(response).to redirect_to(root_url) }
end

def not_administrator
	specify do
		expect(response).to redirect_to(root_url)
    	expect(flash[:notice]).to eq("You are not an authorized administrator.")
    end
end

def inaccessible_without_signin
	specify do
		expect(response).to redirect_to(signin_url)
		expect(flash[:notice]).to eq("Page not accessible. Please sign in or sign up.")
	end
end

def forbidden_without_signin
	specify do
		expect(response).to redirect_to(root_url)
    	expect(flash[:notice]).to eq("Action not permitted!")
    end
end


