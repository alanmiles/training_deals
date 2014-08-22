require 'spec_helper'

describe "EventPages" do
  
  subject { page }

	before(:each) do 
 		Business.any_instance.stub(:geocode).and_return([1,1]) 
	end

	let!(:founder) 			{ FactoryGirl.create(:user) }
	let!(:administrator)	{ FactoryGirl.create(:user) }
	let!(:founder_biz)		{ FactoryGirl.create(:business, created_by: founder.id)}  #founder is automatically an owner
	let!(:ownership_1)		{ FactoryGirl.create(:ownership, business: founder_biz, user: administrator,
								 email_address: administrator.email) }
	let!(:event_method)		{ FactoryGirl.create(:training_method, description: "Seminar",
									event: true) }
	let!(:non_event_method)	{ FactoryGirl.create(:training_method, event: false) }
	let!(:length)			{ FactoryGirl.create(:content_length) }
	let!(:duration)			{ FactoryGirl.create(:duration) }
	let!(:genre_1)			{ FactoryGirl.create(:genre, status: 1) }
	let!(:genre_1_cat_1)		{ FactoryGirl.create(:category, genre: genre_1, status: 1) }
	let!(:genre_1_cat_2)		{ FactoryGirl.create(:category, genre: genre_1, status: 1) }
	let!(:genre_1_cat_1_topic_1)	{ FactoryGirl.create(:topic, category: genre_1_cat_1, status: 1) }
	let!(:genre_1_cat_1_topic_2)	{ FactoryGirl.create(:topic, category: genre_1_cat_1, status: 1) }

	describe "as business administrator" do

		describe "with no products defined" do

			before { sign_in founder }

	  		describe "visit Index page" do

				let!(:no_product_biz)	{ FactoryGirl.create(:business, created_by: founder.id)} 

				before { visit my_business_events_path(no_product_biz) }

				it { should have_selector('h1', "Event schedule")}
				it { should have_selector('h2', "for #{founder_biz.name}, #{founder_biz.city}") }
				it { should_not have_content("Some training activities") }
				it { should have_content("You need to add at least one event-type
					training product before you can start scheduling.") }
			end
		end

		describe "with products defined" do

			let!(:product_1) 	{ FactoryGirl.create(:product, title: "Latest product",
						business: founder_biz,
						topic: genre_1_cat_1_topic_1, training_method: event_method, 
						content_length: nil, content_number: nil, duration_id: duration.id, duration_number: 360) }
			
			let!(:non_event_product) { FactoryGirl.create(:product, title: "Non event",
						business: founder_biz,
						topic: genre_1_cat_1_topic_1, training_method: non_event_method,
						content_length: length) }

			before { sign_in founder }

			describe "with no events scheduled" do

				describe "visit Index page" do

					before { visit my_business_events_path(founder_biz) }

					it { should have_title("Event schedule") }
					it { should have_selector('h1', "Event schedule")}
					it { should have_selector('h2', "for #{founder_biz.name}, #{founder_biz.city}") }
					it { should have_content("Some training activities") }
					it { should_not have_content("You need to add at least one event-type
						training product before you can start scheduling.") }
					it { should_not have_selector('td', text: product_1.title) }
					it { should have_link("<- Business details", href: my_business_path(founder_biz)) }
					it { should have_link("Schedule an event", href: new_my_business_event_path(founder_biz)) }
				end

				describe "visit New page" do

					before { visit new_my_business_event_path(founder_biz) }

					it { should have_title("Add event") }
					it { should have_selector('h1', "Add a training event")}
					it { should have_selector('h2', "for #{founder_biz.name}, #{founder_biz.city}") }
					it { should have_link("<- Back to event schedule", href: my_business_events_path(founder_biz)) }
					it { should have_link("Products", href: my_business_products_path(founder_biz)) }  #checking Business menu displayed
					it { should have_selector("select#event_product_id", text: "#{product_1.title}") }
					it { should_not have_selector("select#event_product_id", 
							text: "#{non_event_product.title}") }   #non-event products are not in Select list
				
					describe "and schedule an event" do

						describe "successfully" do

							before do
								select "#{product_1.title}", from: 'event_product_id'
								fill_in 'event_start_date', with: (Date.today + 14).strftime('%Y-%m-%d')
								fill_in 'event_end_date', with: (Date.today + 21).strftime('%Y-%m-%d')
								find(:css, "#weekdays_[value='Mon']").set(true)
								find(:css, "#weekdays_[value='Wed']").set(true)
								find(:css, "#weekdays_[value='Fri']").set(true)
								select "Evening", from: "Time of day"
								fill_in 'Start time', with: "19:30"
								fill_in 'Finish time', with: "22:00"
								fill_in 'Location', with: "University campus"
								fill_in 'Notes', with: "Piffle"
							end

							it "should create an Event" do
			              		expect { click_button "Create" }.to change(founder_biz.events, :count).by(1) 
			            	end

			            	describe "and redirect to the Show page with correct data added" do

			            		before do 
			            			click_button 'Create'
			            			@event = Event.last
			            		end

			            		it { should have_title("Event details") }
								it { should have_selector('h2', text: "- as seen by other HROOMPH users")}
								it { should have_link("<- All scheduled events", my_business_events_path(founder_biz)) }
								it { should have_link("Update event details ->", event_path(@event)) }
								it { should have_content("Cast yourself in the role of the outsider looking in.") }
								it { should have_selector('div.strong', text: "#{founder_biz.name}") }	
								it { should have_selector('div.strong', text: "#{product_1.title}") }
								it { should have_selector('span.js-toggle-detail', text: "(more..)") }
								it { should have_selector('span.js-toggle-detail-2', text: "(more..)") }	
								it { should have_content("#{founder_biz.full_address}") }     
								pending "test for exclusion of address if it's hidden" 
								it { should_not have_content("#{founder.name} <#{founder.email}>") }  #no owner marked as contactable 
								it { should_not have_content("Phone:") } #no phone number entered for founder_biz
								it { should have_content("#{founder_biz.email}") }
								it { should_not have_content("Reference code:") } #no ref code entered for product
								it { should have_content("#{product_1.content}") }
								it { should have_content("#{@event.start_date.strftime('%a %d %b, %Y')} -> #{@event.end_date.strftime('%a %d %b, %Y')}") }
			            		it { should have_content("Evening : #{@event.start_time.strftime('%l:%M %P')} -> #{@event.finish_time.strftime('%l:%M %P')}") }
			            		it { should have_content("Mon, Wed, Fri") }
			            		it { should have_content("University campus") }
			            		it { should have_content("Piffle")}
			            		pending "image content not tested"
			            	end
						end

						describe "unsuccessfully" do

							describe "with no product reference" do

								it "should not create an Event" do
			              			expect { click_button "Create" }.not_to change(founder_biz.events, :count) 
			              		end

			              		describe "produces an error message on the New page" do

			              			before { click_button 'Create' }

									it { should have_title("Add event") }
									it { should have_content("Please start again - and make sure you select a product in the 'Relating to' box.") }
			              		end			
							end

							describe "with a missing date" do

								before do
									select "#{product_1.title}", from: 'event_product_id'
									fill_in 'event_start_date', with: (Date.today + 14).strftime('%Y-%m-%d')
									find(:css, "#weekdays_[value='Mon']").set(true)
									find(:css, "#weekdays_[value='Wed']").set(true)
									select "Evening", from: "Time of day"
								end

								it "should not create an Event" do
			              			expect { click_button "Create" }.not_to change(founder_biz.events, :count) 
			              		end

			              		describe "re-renders the New page, retaining data entered" do

			              			before { click_button 'Create' }

									it { should have_title("Add event") }
									it { should have_selector('li', text: "* End date can't be blank") }
			              			it { should have_select('event_product_id', selected: "#{product_1.title}")}
			              			it { should have_checked_field("weekdays_") }   #better test required to match day selected
			              			it { should have_unchecked_field("weekdays_") }
			              			it { should have_select('event_time_of_day', selected: "Evening") }
			              		end		

							end
						end
					end
				end

			end

			describe "with events previously scheduled" do

				let!(:event)		{ FactoryGirl.create(:event, product: product_1) }

				describe "visit Index page" do
					before { visit my_business_events_path(founder_biz) }

					it { should have_title("Event schedule") }
					it { should have_selector('h1', "Event schedule")}
					it { should have_selector('h2', "for #{founder_biz.name}, #{founder_biz.city}") }
					it { should_not have_content("Some training activities") }
					it { should_not have_content("You need to add at least one event-type
						training product before you can start scheduling.") }
					it { should have_selector('td', text: product_1.title) }
					it { should have_selector('td', text: event.start_date.strftime("%d-%b-%y")) }
					it { should have_selector('td', text: event.end_date.strftime("%d-%b-%y")) }
					it { should have_link('details', href: event_path(event))}
					it { should have_link('delete', href: event_path(event)) }   #provided not a HROOMPH special
																				#otherwise 'cancel'
					it { should have_link("<- Business details", href: my_business_path(founder_biz)) }
					it { should have_link("Schedule an event", href: new_my_business_event_path(founder_biz)) }

					#business menu links:
					it { should have_link("Business home page", href: my_businesses_path) }
					it { should have_link("Products", href: my_business_products_path(founder_biz)) }
					it { should have_link("User home page", user_path(founder) ) }

					pending "Nothing built or tested for 'Cancel' yet"
					pending "column sorting not tested"
				end

				describe "visit Show page with ref_code and business phone" do
			
					let!(:event_2) { FactoryGirl.create(:event, product: product_1, time_of_day: "Morning") }
					
					before do
						founder_biz.phone = "0770-604022"
						founder_biz.save
						product_1.ref_code = "AAA-1111"
						product_1.save
						visit event_path(event_2)
					end

					it { should have_title("Event details") }
					it { should have_content("Phone:") }
					it { should have_content("#{founder_biz.phone}") }
					it { should_not have_content("#{founder.name} <#{founder.email}>") }
					it { should have_content("Reference code:") }
					it { should have_content("#{event_2.start_date.strftime('%a %d %b, %Y')} -> #{event_2.end_date.strftime('%a %d %b, %Y')}") }
            		it { should have_content("Morning") }
            		it { should_not have_content("Morning : ") }
            		it { should_not have_content("Mon, Wed, Fri") }
            		it { should_not have_content("Location:") }
            		it { should_not have_content("Notes:")}

            		describe "when team member is contactable but no phone" do

            			before do 
            				ownership_1.contactable = true
            				ownership_1.save
            				visit event_path(event_2)
            			end

            			it { should_not have_content("Phone:") }

            			it { should have_content("Contact:") }
            			it { should have_content("#{administrator.name} <#{administrator.email}>") }
            			it { should_not have_content("#{administrator.name} <#{administrator.email} - ") }
            			it { should_not have_content(founder_biz.phone) }

            			describe "when team member name and email have changed" do

            				let!(:old_name) { "#{administrator.name}" }
            				let!(:old_email) { "#{administrator.email}" }
            				let(:changed_name) { "Changed name" }
            				let(:changed_email) { "changed_name@example.com"}
            				
            				before do
            					administrator.name = changed_name
            					administrator.email = changed_email
            					administrator.password = "foobar"
            					administrator.password_confirmation = "foobar"
            					administrator.save
            					visit event_path(event_2)
            				end

            				it { should have_content("#{changed_name} <#{changed_email}>") }
            				it { should_not have_content("#{old_name} <#{old_email}>") }
            			end

            			describe "when team member phone is added" do

            				before do
            					ownership_1.phone = "0999 99999"
            					ownership_1.save
            					visit event_path(event_2)
            				end

            				it { should have_content("#{administrator.name} <#{administrator.email} - #{ownership_1.phone}>") }
            				it { should_not have_content(founder_biz.phone) }
            			end
            		end
				end
			end
		end
	end

	describe "when not signed in" do

	end

	describe "when signed in but not as administrator of this business" do

	end
end
