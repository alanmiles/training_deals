require 'spec_helper'

describe "NonSignedSearches" do
  
  subject { page }

	before(:each) do 
 		Business.any_instance.stub(:geocode).and_return([1,1]) 
 		Visitor.any_instance.stub(:geocode).and_return([1,1]) 
	end

	#exchange-rates
	let!(:default_rate)		{ FactoryGirl.create(:exchange_rate) }
	let!(:uk_rate)			{ FactoryGirl.create(:exchange_rate, currency_code: "GBP", rate: 0.637742) }
	let!(:us_rate)			{ FactoryGirl.create(:exchange_rate, currency_code: "USD", rate: 1) }

	#users
	let!(:founder) 			{ FactoryGirl.create(:user) }
	let!(:administrator)	{ FactoryGirl.create(:admin) }
	let!(:distant_owner)	{ FactoryGirl.create(:user, location: "32 Victoria Street, Birmingham, B9 5AD",
								city: "Birmingham", latitude: 52.486243,longitude: -1.890401 ) }
	let!(:country_owner)	{ FactoryGirl.create(:user, location: "165 Vale Road, Tonbridge, Kent, TN9 1SP",
								city: "Tonbridge", latitude: 51.190605, longitude: 0.282366) }
	let!(:foreign_owner)	{ FactoryGirl.create(:user, location: "23 High Street, Southborough, MA 01772, USA",
								city: "Southborough", country: "United States", latitude: 42.300513, 
								longitude: -71.573759) }

	#businesses and owners
	let!(:founder_biz)		{ FactoryGirl.create(:business, created_by: founder.id) }  #founder is automatically an owner
	let!(:other_biz)		{ FactoryGirl.create(:business, created_by: founder.id) }
	let!(:closed_biz)		{ FactoryGirl.create(:business, created_by: founder.id, inactive: true) }
	let!(:distant_biz)		{ FactoryGirl.create(:business, created_by: distant_owner.id, 
								street_address: "32 Victoria Street", city: "Birmingham", latitude: 52.486243,
								longitude: -1.890401) }
	let!(:country_biz)		{ FactoryGirl.create(:business, created_by: country_owner.id, 
								street_address: "165 Vale Road", city: "Tonbridge", latitude: 51.190605,
								longitude: 0.282366) }
	let!(:foreign_biz)		{ FactoryGirl.create(:business, created_by: foreign_owner.id, 
								street_address: "23 High Street", city: "Southborough", country: "United States", 
								latitude: 42.300513, longitude: -71.573759) }

	let!(:ownership_1)		{ FactoryGirl.create(:ownership, business: founder_biz, user: administrator,
								 email_address: administrator.email) }
	let!(:ownership_2)		{ FactoryGirl.create(:ownership, business: other_biz, user: administrator,
								 email_address: administrator.email) }

	#product parameters
	let!(:event_method)		{ FactoryGirl.create(:training_method, description: "Seminar",
									event: true) }
	let!(:non_event_method)	{ FactoryGirl.create(:training_method, description: "Book", event: false) }
	let!(:length)			{ FactoryGirl.create(:content_length) }
	let!(:duration)			{ FactoryGirl.create(:duration) }

	#topic tree
	let!(:genre_1)				{ FactoryGirl.create(:genre, status: 1) }
	let!(:genre_2)				{ FactoryGirl.create(:genre, description: 'Work', status: 1) }
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
	let!(:pending_topic)			{ FactoryGirl.create(:topic, category: genre_1_cat_1, status: 2 ) }

	#product list
	let!(:product_1) 	{ FactoryGirl.create(:product, title: "Latest product 1",
				business: founder_biz,
				topic: genre_1_cat_1_topic_1, training_method: event_method, 
				content_length: nil, content_number: nil, duration_id: duration.id, 
				duration_number: 360, qualification: "Qualification 1") }

	let!(:distant_product_1) 	{ FactoryGirl.create(:product, title: "Distant product 1",
				business: distant_biz,
				topic: genre_1_cat_1_topic_1, training_method: event_method, 
				content_length: nil, content_number: nil, duration_id: duration.id, 
				duration_number: 360) }

	let!(:country_product_1) 	{ FactoryGirl.create(:product, title: "Country product 1",
				business: country_biz,
				topic: genre_1_cat_1_topic_1, training_method: event_method, 
				content_length: nil, content_number: nil, duration_id: duration.id, 
				duration_number: 360) }

	let!(:foreign_product_1) 	{ FactoryGirl.create(:product, title: "Foreign product 1",
				business: foreign_biz,
				topic: genre_1_cat_1_topic_1, training_method: event_method, 
				content_length: nil, content_number: nil, duration_id: duration.id, 
				duration_number: 360,
				currency: "USD", standard_cost: 600) }
	
	let!(:non_event_product) { FactoryGirl.create(:product, title: "Non event",
				business: founder_biz,
				topic: genre_1_cat_1_topic_1, training_method: non_event_method,
				qualification: "Qualification 1", content_length: length) }

	let!(:non_event_product_distant) { FactoryGirl.create(:product, title: "Non event distant",
				business: distant_biz,
				topic: genre_1_cat_1_topic_1, training_method: non_event_method,
				content_length: length) }

	let!(:non_event_product_country) { FactoryGirl.create(:product, title: "Non event country",
				business: country_biz,
				topic: genre_1_cat_1_topic_1, training_method: non_event_method,
				content_length: length) }

	let!(:non_event_product_foreign) { FactoryGirl.create(:product, title: "Non event foreign",
				business: foreign_biz,
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

	let!(:genre1_cat2_product) { FactoryGirl.create(:product, title: "Topic2 Product",
				business: founder_biz,
				topic: genre_1_cat_2_topic_1, training_method: non_event_method,
				content_length: length) }

	let!(:closed_biz_product) 	{ FactoryGirl.create(:product, title: "Closed biz product",
				business: closed_biz,
				topic: genre_1_cat_1_topic_1, training_method: event_method, 
				content_length: nil, content_number: nil, duration_id: duration.id, duration_number: 360) }


	describe "visit the Home page" do

		before { visit root_path }

		it { should have_content("11 topics to choose from.") }
		it { should_not have_content("(11 found)") }
		it { should have_selector("#genre_select", text: "#{genre_1.description}") }
		it { should have_selector("#genre_select", text: "#{genre_2.description}") }
		it { should have_button("View results") }

		describe "select a Genre", js: true do

			before { select "#{genre_1.description}", from: 'genre_select' }

			it { should have_content("11 topics to choose from.") }
			it { should have_content("10 found)") }
			it { should have_selector("#cat_select", text: "#{genre_1_cat_1.description}") }
			it { should have_selector("#cat_select", text: "#{genre_1_cat_2.description}") }
			it { should_not have_selector("#cat_select", text: "#{genre_2_cat_1.description}") }
			it { should_not have_selector("#cat_select", text: "#{genre_1_pending_cat.description}") }
			it { should_not have_selector("#cat_select", text: "#{genre_1_no_topic_cat.description}") }

			describe  "select a Category" do

				before { select "#{genre_1_cat_1.description}", from: 'cat_select' }

				it { should have_content("9 found)") }
				it { should have_selector("#topic_select", text: "#{genre_1_cat_1_topic_2.description}") }
				it { should_not have_selector("#topic_select", text: "#{genre_1_cat_2_topic_1.description}") }
			
				describe "select a Topic with Products found" do

					before { select "#{genre_1_cat_1_topic_1.description}", from: 'topic_select' }

					it { should have_content("9 found)") }
				end

				describe "select a Topic with no Products found" do

					before { select "#{genre_1_cat_1_topic_2.description}", from: 'topic_select' }

					it { should have_content("0 found)") }
				
					describe "deselect genre_1" do

						before { select "Please select", from: 'genre_select' }

						it { should_not have_content("11 found)") }
						it { should_not have_selector("#cat_select", text: "#{genre_1_cat_1.description}") }
						it { should_not have_selector("#cat_select", text: "#{genre_1_cat_2.description}") }
					#	it { should_not have_selector("#topic_select", text: "#{genre_1_cat_1_topic_2.description}") }  #unnecessary since cant run search anyway

					end
				end
			end
		end

	end

	describe "Conduct a search" do

		before { visit root_path }

		describe "Without selecting a genre" do

			before { click_button "View results" }

			pending "can't test because of modal dialog - should not pass to results controller"

		end

		describe "When genre is selected, but not category or topic" do

			before do
				select "#{genre_1.description}", from: 'genre_select'
				click_button "View results"
			end

			it { should have_title("Search results") }
			it { should have_selector('h1', text: "Search results") }
			it { should have_link("<- Back to Home Page", href: root_path) }
			it { should have_selector("li#product_#{product_1.id}", text: product_1.title) }
			it { should have_selector("li#product_#{genre1_cat2_product.id}") }
			it { should have_selector("li#product_#{non_event_product.id}") }
			it { should_not have_selector("li#product_#{genre2_product.id}") }
			it { should_not have_selector("li#product_#{delisted_product.id}") }
			it { should_not have_selector("li#product_#{closed_biz_product.id}") }

			it { should have_content("#{product_1.title}") }
			it { should have_content("#{product_1.training_method.description}") }
			it { should have_content("#{product_1.formatted_standard_price}") }
			it { should have_content("360 minutes") }
			it { should have_content("#{product_1.content}") }
			it { should have_content("#{product_1.qualification}") }		#because qualification declared for product_1
			it { should have_content("#{product_1.business.name}, #{product_1.business.city}, #{product_1.business.country}") }
			it { should have_content("Latest product 1") }
			it { should have_content("Distant product 1") }
			it { should have_content("Country product 1") }
			it { should have_content("Foreign product 1") }
			it { should have_content("Non event") }
			it { should have_content("Non event distant") }
			it { should have_content("Non event country") }
			it { should have_content("Non event foreign") }
			it { should have_content("Admin product") }
			it { should have_content("Topic2 Product") }
			it { should have_content("Displaying all 10 products") }
			it { should have_selector("li#product_#{non_event_product_foreign.id}", text: "(approx £") }
			pending "cannot test converted price itself - rspec complains of coercing ExchangeRate into Big Decimal"
			it { should_not have_selector("li#product_#{product_1.id}", text: "(approx £") }

			describe "filter by format", js: true do

				#before do
				#	find("#method-filter").select("#{event_method.description}")
				#	sleep 1
				#end 

				#it { should have_content("Latest product 1") }
				#it { should_not have_content("Non event") }
				#it { should have_content("Displaying all 5 products") }
				pending "find more reliable test method for js"

				describe "refilter by qualification" do

					#before do
					#	fill_in "qual_filter", with: "Q"
					#	sleep 1	
					#end

					#it { should have_content("Displaying all 5 products") }
					pending "result is cleared before transaction can run - don't know how to fix"
				end


				describe "refilter by location - nearby" do

					pending "not tested - special tests need setting up for Geocoder"
				end	
			end
		end
		
	end
end
