require 'spec_helper'

describe "EventPages" do
  
  subject { page }

	before(:each) do 
 		Business.any_instance.stub(:geocode).and_return([1,1]) 
	end

	let!(:founder) 			{ FactoryGirl.create(:user) }
	let!(:administrator)	{ FactoryGirl.create(:user) }
	let!(:founder_biz)		{ FactoryGirl.create(:business, created_by: founder.id)}  #founder is automatically an owner
	let!(:administrator_biz) { FactoryGirl.create(:business, created_by: administrator.id)}
					
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

			let!(:admin_product) 	{ FactoryGirl.create(:product, title: "Admin product",
						business: administrator_biz,
						topic: genre_1_cat_1_topic_1, training_method: event_method, 
						content_length: nil, content_number: nil, duration_id: duration.id, duration_number: 360) }

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
								select "#{product_1.title} (#{founder_biz.currency_symbol} #{sprintf('%.2f', product_1.standard_cost)})", 
									from: 'event_product_id'
								fill_in 'event_start_date', with: (Date.today + 14).strftime('%Y-%m-%d')
								fill_in 'event_end_date', with: (Date.today + 21).strftime('%Y-%m-%d')
								fill_in 'event_places_available', with: 16
								fill_in 'event_places_sold', with: 4
								fill_in 'event_price', with: 100
								find(:css, "#weekdays_Mon").set(true)
								find(:css, "#weekdays_Wed").set(true)
								find(:css, "#weekdays_Fri").set(true)
								select "Evening", from: "Time of day"
								fill_in 'event_start_time', with: "19:30"
								fill_in 'event_finish_time', with: "22:00"
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
								it { should have_selector('div.subhead', text: "- as seen by other HROOMPH users")}
								it { should have_link("<- All current & future events", my_business_events_path(founder_biz)) }
								it { should_not have_link("Completed events", href: my_business_previous_events_path(founder_biz)) }
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
			            		it { should have_content("Accepting bookings") }
			            		it { should_not have_content("Sold out") }
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
									find(:css, "#weekdays_Mon").set(true)
									find(:css, "#weekdays_Wed").set(true)
									select "Evening", from: "Time of day"
								end

								it "should not create an Event" do
			              			expect { click_button "Create" }.not_to change(founder_biz.events, :count) 
			              		end

			              		describe "re-renders the New page, retaining data entered" do

			              			before { click_button 'Create' }

									it { should have_title("Add event") }
									it { should have_selector('li', text: "* End date can't be blank") }
			              			it { should have_select('event_product_id', 
			              				selected: "#{product_1.title} (#{founder_biz.currency_symbol} #{sprintf('%.2f', product_1.standard_cost)})") }
			              			it { should have_checked_field("weekdays_Mon") } 
			              			it { should have_unchecked_field("weekdays_Sun") }
			              			it { should have_select('event_time_of_day', selected: "Evening") }
			              		end		

							end
						end
					end
				end

			end

			describe "with current/future Events scheduled" do

				let!(:event)		{ FactoryGirl.create(:event, product: product_1,
										start_date: Date.today + 30, end_date: Date.today + 37) }
				let!(:old_event)	{ FactoryGirl.create(:event, product: product_1,
										start_date: Date.today - 30, end_date: Date.today - 23) }
				let!(:ongoing_event) { FactoryGirl.create(:event, product: product_1,
										start_date: Date.today - 7, end_date: Date.today + 7) }


				describe "visit Index page" do
					before { visit my_business_events_path(founder_biz) }

					it { should have_title("Event schedule") }
					it { should have_selector('h1', "Event schedule")}
					it { should have_selector('h2', "for #{founder_biz.name}, #{founder_biz.city}") }
					it { should_not have_content("Some training activities") }
					it { should_not have_content("You need to add at least one event-type
						training product before you can start scheduling.") }
					it { should have_selector("tr#event_#{event.id}", text: product_1.title) }
					it { should have_selector("tr#event_#{event.id}", text: event.start_date.strftime("%d-%b-%y")) }
					it { should have_selector("tr#event_#{event.id}", text: event.end_date.strftime("%d-%b-%y")) }
					it { should have_link('details', href: event_path(event))}
					it { should have_link('delete', href: event_path(event)) }   #provided not a HROOMPH special
																				#otherwise 'cancel'
					it { should have_selector("tr#event_#{ongoing_event.id}", 
								text: ongoing_event.start_date.strftime("%d-%b-%y")) }
					it { should_not have_selector("tr#event_#{old_event.id}", 
								text: old_event.start_date.strftime("%d-%b-%y")) }
					it { should have_link("<- Business details", href: my_business_path(founder_biz)) }
					it { should have_link("Schedule an event", href: new_my_business_event_path(founder_biz)) }
					#list order asc
					it { should have_selector("table tr:nth-child(2)", text: ongoing_event.start_date.strftime("%d-%b-%y")) }
					it { should have_selector("table tr:nth-child(3)", text: event.start_date.strftime("%d-%b-%y")) }
					
					#business menu links:
					it { should have_link("Business home page", href: my_businesses_path) }
					it { should have_link("Products", href: my_business_products_path(founder_biz)) }
					it { should have_link("User home page", user_path(founder) ) }

					pending "Nothing built or tested for 'Cancel' yet"
					pending "column sorting not tested"
					pending "search not tested"

					it "should be able to delete the product and redirect correctly" do   #provided never scheduled
		            
			            expect do
			              click_link('delete', href: event_path(event))
			            end.to change(founder_biz.events, :count).by(-1)
			            
			            expect(page).to have_title('Event schedule')
			            expect(page).not_to have_selector("tr#event_#{event.id}")

						expect(page).not_to have_selector('td', text: event.start_date.strftime("%d-%b-%y"))
						expect(page).not_to have_selector('td', text: event.end_date.strftime("%d-%b-%y"))
			            expect(page).to have_selector("tr#event_#{ongoing_event.id}", 
								text: ongoing_event.start_date.strftime("%d-%b-%y"))
			        end
				end

				describe "pagination link" do

					before do
						(0..15).each do |i|
							FactoryGirl.create(:event, product_id: admin_product.id)
						end
						sign_in administrator
					    visit my_business_events_path(administrator_biz)
					end
					
					it { should have_selector('div.pagination') }
				    
				end

				describe "visit Show page with ref_code and business phone" do
			
					let!(:event_2) { FactoryGirl.create(:event, product: product_1, 
						start_date: Date.today + 50, end_date: Date.today + 51,
						places_available: 12, places_sold: 12,
						time_of_day: "Morning") }
					
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
            		it { should_not have_content("This event has now finished.") }
            		it { should_not have_content("Special pricing") }
            		it { should have_content("Sold out") }

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

            		describe "when Event price is discounted by more than 1%" do

            			before do
            				event_2.price = event_2.price - 5
            				event_2.save
            				visit event_path(event_2)
            			end

            			it { should have_content("Special pricing: £ 95.00 - SAVE 5% !") }
            		end

            		describe "when Event discount is a fraction" do

            			before do
            				event_2.price = event_2.price - 4.75
            				event_2.save
            				visit event_path(event_2)
            			end

            			it { should have_content("Special pricing: £ 95.25 - SAVE 4.75% !") }

            		end

            		describe "when Event price is discounted by less than 1%" do

            			before do
            				event_2.price = event_2.price - 0.5
            				event_2.save
            				visit event_path(event_2)
            			end

            			it { should have_content("Special pricing: £ 99.50") }
            			it { should_not have_content("SAVE") }
            		end

            		describe "when Event price is free" do

            			before do
            				event_2.price = 0
            				event_2.save
            				visit event_path(event_2)
            			end

            			it { should have_content("* * FREE! SAVE £ 100.00 ! * *") }
            		end

            		describe "when Product and Event prices are free" do

            			before do
            				product_1.standard_cost = 0
            				product_1.save
            				event_2.price = 0
            				event_2.save
            				visit event_path(event_2)
            			end

            			it { should_not have_content("* * FREE! SAVE") }
            			it { should have_content("* * FREE! * *") }
            		end

            		describe "when Event price is higher than Product price" do

            			before do
            				event_2.price = event_2.price + 5
            				event_2.save
            				visit event_path(event_2)
            			end

            			it { should have_content("Special pricing: £ 105.00") }
            			it { should_not have_content("SAVE") }
            		end
				end

				describe "visit Edit page" do

					let!(:arrive_time) { "10:00"}
					before do
						event.attendance_days = "Mon, Wed"
						event.time_of_day = "Varies"
						event.start_time = arrive_time
						event.finish_time = "12:30"
						event.places_sold = 12
						event.places_available = 12
						event.save
						visit edit_event_path(event)
					end

					it { should have_title('Edit event') }
					it { should have_selector('h1', "Edit event")}
					it { should have_selector('h2', "for '#{product_1.title}'") }
					it { should have_link('<- Drop changes', href: event_path(event)) }
					it { should have_link('Products', href: my_business_products_path(founder_biz)) }
					it { should have_selector("input#event_start_date[value='#{event.start_date}']") }
					it { should have_selector("input#event_end_date[value='#{event.end_date}']") }
					it { should have_checked_field("weekdays_Mon") }
					it { should have_checked_field("weekdays_Wed") }
					it { should have_unchecked_field("weekdays_Tue") }
					it { should have_select('event_time_of_day', selected: "Varies") }
					it { should have_selector("input#event_start_time[value='#{event.start_time.strftime('%H:%M')}']") }
					it { should have_selector("input#event_finish_time[value='#{event.finish_time.strftime('%H:%M')}']") }
					it { should_not have_content("Now finished. Only change details if absolutely essential.") }

					describe "Update the event" do

						describe "successfully" do

							before do
								find(:css, "#weekdays_Mon").set(false)
								find(:css, "#weekdays_Tue").set(true)
								select "Not displayed", from: "Time of day"
								fill_in 'event_finish_time', with: "13:00"
								fill_in 'event_places_sold', with: event.places_available - 1
								click_button 'Update'
							end

							it { should have_title('Event details') }
							it { should have_content("#{event.start_time.strftime('%l:%M %P')} -> 1:00 pm") }
			            	it { should have_content("Tue, Wed") }
			            	it { should_not have_content("Not displayed") }
			            	it { should have_content("1 place left") }
						end

						describe "unsuccessfully" do

							before do
								find(:css, "#weekdays_Mon").set(false)
								find(:css, "#weekdays_Tue").set(true)
								select "Not displayed", from: "Time of day"
								fill_in 'event_finish_time', with: "13:00"
								fill_in 'event[start_time]', with: ""
								click_button 'Update'
							end

							it { should have_title('Edit event') }
							it { should_not have_checked_field("weekdays_Mon") }
							it { should have_checked_field("weekdays_Tue") }
							it { should have_checked_field("weekdays_Wed") }
							it { should have_select('event_time_of_day', selected: "Not displayed") }
							it { should have_selector("input#event_finish_time[value='13:00']") }
							it { should have_content("Start time can't be blank")}
						end
					end
				end
			end

			describe "with events scheduled but only in the past" do

				let!(:old_event)	{ FactoryGirl.create(:event, product: product_1,
										start_date: Date.today - 30, end_date: Date.today - 23) }
				let!(:last_old_event)	{ FactoryGirl.create(:event, product: product_1,
										start_date: Date.today - 60, end_date: Date.today - 53) }
				let!(:first_old_event)	{ FactoryGirl.create(:event, product: product_1,
										start_date: Date.today - 15, end_date: Date.today - 8) }
				


				describe "Events/Index page" do

					before { visit my_business_events_path(founder_biz) }

					it { should have_title("Event schedule") }
					it { should have_selector('h2', "for #{founder_biz.name}, #{founder_biz.city}") }
					it { should have_content("There are no current or future events scheduled for this business.") }
					it { should_not have_selector("tr#event_#{old_event.id}", 
								text: old_event.start_date.strftime("%d-%b-%y")) }
					it { should have_link("Schedule an event ->", href: new_my_business_event_path(founder_biz)) }
					it { should have_link("Completed events", href: my_business_previous_events_path(founder_biz)) }
					#business menu links:
					it { should have_link("Products", href: my_business_products_path(founder_biz)) }	
				end

				describe "visit the Previous_Events/Index page" do

					before { visit my_business_previous_events_path(founder_biz) }

					it { should have_title("Completed events") }
					it { should have_selector('h1', "Completed events") }
					it { should have_selector('h2', "for #{founder_biz.name}, #{founder_biz.city}") }
					it { should have_selector("tr#event_#{old_event.id}", 
								text: old_event.start_date.strftime("%d-%b-%y")) }
					it { should have_link("Schedule a new event ->", href: new_my_business_event_path(founder_biz)) }
					it { should have_link("All current & future events ->", href: my_business_events_path(founder_biz)) }
					#list order descending
					it { should have_selector("table tr:nth-child(2)", text: first_old_event.start_date.strftime("%d-%b-%y")) }
					it { should have_selector("table tr:nth-child(3)", text: old_event.start_date.strftime("%d-%b-%y")) }
					it { should have_selector("table tr:nth-child(4)", text: last_old_event.start_date.strftime("%d-%b-%y")) }
					#it { should have_selector("tr#dates td:nth-child(2)", content: @date2.content) }

					#business menu links:
					it { should have_link("Products", href: my_business_products_path(founder_biz)) }

					it "should be able to delete the product and redirect correctly" do   #provided never scheduled
		            
			            expect do
			              click_link('delete', href: event_path(old_event))
			            end.to change(founder_biz.events, :count).by(-1)
			            
			            expect(page).to have_title('Completed events')
			            expect(page).not_to have_selector("tr#event_#{old_event.id}")

						expect(page).not_to have_selector('td', text: old_event.start_date.strftime("%d-%b-%y"))
						expect(page).not_to have_selector('td', text: old_event.end_date.strftime("%d-%b-%y"))
			            expect(page).to have_selector("tr#event_#{first_old_event.id}", 
								text: first_old_event.start_date.strftime("%d-%b-%y"))
			        
			            pending "return to current event schedule after deleting the last prevous event - untested"
			        end
				end

				pending 'pagination for Previous Events untested'

				describe "Show page" do

					before { visit event_path(old_event) }

					it { should have_title("Event details") }
					it { should have_content("This #{founder_biz.currency_symbol} #{sprintf('%.2f', old_event.price)} event has now finished.") }

				end

				describe "Edit page" do

					before { visit edit_event_path(old_event) }

					it { should have_title('Edit event') }
					it { should have_content("Now finished. Only change details if absolutely essential.") }

				end
			end
		end
	end

	describe "when not signed in" do

		describe "when product doesn't exist" do

			describe "Index" do
				
				describe "redirect to the signin page" do
				
					before { get my_business_events_path(founder_biz) }
					inaccessible_without_signin
				end

				describe "go to correct Index page after signing in" do

					before do
						visit my_business_events_path(founder_biz)
						valid_signin(founder)
					end
					
					specify do
						expect(page).to have_title('Event schedule')
						expect(page).to have_selector('h2', "for #{founder_biz.name}, #{founder_biz.city}")
						expect(page).to have_content("You need to add at least one event-type
											training product before you can start scheduling.")
					end

					describe "but don't go to this index page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in founder
						end	

						specify { expect(page).not_to have_title('Event schedule') }
					end
				end
			end
		end

		describe "when product exists but no events scheduled" do

			let!(:product_1) 	{ FactoryGirl.create(:product, title: "Latest product",
				business: founder_biz,
				topic: genre_1_cat_1_topic_1, training_method: event_method, 
				content_length: nil, content_number: nil, duration_id: duration.id, duration_number: 360) }

			describe "Index" do

				describe "redirect to the signin page" do
				
					before { get my_business_events_path(founder_biz) }
					inaccessible_without_signin
				end

				describe "go to correct Index page after signing in" do

					before do
						visit my_business_events_path(founder_biz)
						valid_signin(founder)
					end
					
					specify do
						expect(page).to have_title('Event schedule')
						expect(page).to have_selector('h2', "for #{founder_biz.name}, #{founder_biz.city}")
						expect(page).to have_content("Some training activities")
						expect(page).not_to have_content("You need to add at least one event-type
							training product before you can start scheduling.")
					end

					describe "but don't go to this index page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in founder
						end	

						specify { expect(page).not_to have_title('Event schedule') }
					end
				end
			end
		end

		describe "when both product and events exist" do

			let!(:product_1) 	{ FactoryGirl.create(:product, title: "Latest product",
				business: founder_biz,
				topic: genre_1_cat_1_topic_1, training_method: event_method, 
				content_length: nil, content_number: nil, duration_id: duration.id, duration_number: 360) }
			
			let!(:event)		{ FactoryGirl.create(:event, product: product_1) }

			describe "Index" do
					
				describe "redirect to the signin page" do
				
					before { get my_business_events_path(founder_biz) }
					inaccessible_without_signin
				end

				describe "go to correct Index page after signing in" do

					before do
						visit my_business_events_path(founder_biz)
						valid_signin(founder)
					end
					
					specify do
						expect(page).to have_title('Event schedule')
						expect(page).to have_selector('h2', "for #{founder_biz.name}, #{founder_biz.city}")
						expect(page).to have_selector("tr#event_#{event.id}", text: product_1.title)
						expect(page).to have_selector("tr#event_#{event.id}", text: event.start_date.strftime("%d-%b-%y"))
						expect(page).to have_selector("tr#event_#{event.id}", text: event.end_date.strftime("%d-%b-%y"))

					end

					describe "but don't go to this index page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in founder
						end	

						specify { expect(page).not_to have_title('Event schedule') }
					end
				end
			end

			describe "Show" do

				before { get event_path(event) }
				inaccessible_without_signin

				describe "go to correct Show page after signing in" do

					before do
						visit event_path(event)
						valid_signin(founder)
					end
					
					specify do
						expect(page).to have_title("Event details")
						expect(page).to have_link("Update event details ->", event_path(event))
						expect(page).to have_content("Cast yourself in the role of the outsider looking in.")
						expect(page).to have_selector('div.strong', text: "#{founder_biz.name}")
						expect(page).to have_selector('span.js-toggle-detail', text: "(more..)")
						expect(page).to have_content("#{product_1.content}")
						expect(page).to have_content("#{event.start_date.strftime('%a %d %b, %Y')} -> #{event.end_date.strftime('%a %d %b, %Y')}")
					end

					describe "but don't go to this Show page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in founder
						end	

						specify { expect(page).not_to have_title("Event details") }
					end
				end
			end

			describe "Edit" do

				before { get edit_event_path(event) }
				inaccessible_without_signin

				describe "go to correct Edit page after signing in" do

					before do
						visit edit_event_path(event)
						valid_signin(founder)
					end
					
					specify do
						expect(page).to have_title("Edit event")
						expect(page).to have_link('Products', href: my_business_products_path(founder_biz))
						expect(page).to have_selector("input#event_start_date[value='#{event.start_date}']")
					end

					describe "but don't go to this Edit page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in founder
						end	

						specify { expect(page).not_to have_title("Edit event") }
					end
				end
			end

			describe "New" do

				before { get new_my_business_event_path(founder_biz) }
				inaccessible_without_signin

				describe "go to correct New page after signing in" do

					before do
						visit new_my_business_event_path(founder_biz)
						valid_signin(founder)
					end
					
					specify do
						expect(page).to have_title("Add event")
			    		expect(page).to have_link("<- Back to event schedule", href: my_business_events_path(founder_biz))
						expect(page).to have_link("Products", href: my_business_products_path(founder_biz)) #checking Business menu displayed
						expect(page).to have_selector("select#event_product_id", text: "#{product_1.title}")
					end

					describe "but don't go to this New page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in founder
						end	

						specify { expect(page).not_to have_title('Add event') }
					end
				end
			end

			describe "attempting to manipulate data" do

				describe "Create" do

              		let(:params) do
                		{ event: { 	product_id: product_1.id,
            						start_date: Date.today + 60,
            						end_date: Date.today + 67, 
            						created_by: 1  } }
              		end
              
              		it "should not create a new Product" do
                		expect do
                  			post my_business_events_path(founder_biz, params)
                		end.not_to change(Event, :count)
              		end

              		describe "should redirect to root" do

                		before { post my_business_events_path(founder_biz, params) }
                		forbidden_without_signin
              		end
            	end

            	describe "Update" do

              		let(:new_start_date)  { Date.today - 1 }
              		let(:params) do
                		{ event: { start_date: new_start_date } }
              		end
              
              		describe "should not modify the existing event" do
                
                		before { patch event_path(event), params } 
                		specify { expect(event.reload.start_date).not_to eq new_start_date }
              		end

              		describe "should redirect to root" do

                		before { patch event_path(event, params) }
                		forbidden_without_signin
              		end
            	end

            	describe "Destroy" do

              		it "should not delete the existing Event" do
                		expect do
                  			delete event_path(event)
                		end.not_to change(Event, :count)
              		end

              		describe "should redirect to root" do

                		before { delete event_path(event) }
                		forbidden_without_signin
                	end
              	end
			end
		end

		describe "when completed events exist" do

			let!(:product_1) 	{ FactoryGirl.create(:product, title: "Latest product",
				business: founder_biz,
				topic: genre_1_cat_1_topic_1, training_method: event_method, 
				content_length: nil, content_number: nil, duration_id: duration.id, duration_number: 360) }
			
			let!(:old_event)	{ FactoryGirl.create(:event, product: product_1,
									start_date: Date.today - 30, end_date: Date.today - 20) }

			describe "PreviousEvents/Index" do
					
				describe "redirect to the signin page" do
				
					before { get my_business_previous_events_path(founder_biz) }
					inaccessible_without_signin
				end

				describe "go to correct Index page after signing in" do

					before do
						visit my_business_previous_events_path(founder_biz)
						valid_signin(founder)
					end
					
					specify do
						expect(page).to have_title('Completed events')
						expect(page).to have_selector('h2', "for #{founder_biz.name}, #{founder_biz.city}")
						expect(page).to have_selector("tr#event_#{old_event.id}", text: product_1.title)
						expect(page).to have_selector("tr#event_#{old_event.id}", text: old_event.start_date.strftime("%d-%b-%y"))
						expect(page).to have_selector("tr#event_#{old_event.id}", text: old_event.end_date.strftime("%d-%b-%y"))

					end

					describe "but don't go to this index page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in founder
						end	

						specify { expect(page).not_to have_title('Completed events') }
					end
				end
			end
		end
	end

	describe "when signed in but not as administrator of this business" do

		let!(:product_1) 	{ FactoryGirl.create(:product, title: "Latest product",
			business: founder_biz,
			topic: genre_1_cat_1_topic_1, training_method: event_method, 
			content_length: nil, content_number: nil, duration_id: duration.id, duration_number: 360) }
		
		let!(:event)		{ FactoryGirl.create(:event, product: product_1) }
		let!(:non_authorized_user)	{ FactoryGirl.create(:user) }
		let!(:non_authorized_biz)	{ FactoryGirl.create(:business, created_by: non_authorized_user.id)} 

		describe "displaying forms" do
			before do
				sign_in non_authorized_user
				visit my_business_path(non_authorized_biz)
			end

			describe "Index page" do

				before { visit my_business_events_path(founder_biz) }
				
				it { should have_content("The page you requested doesn't belong to you") }
				it { should have_title("#{non_authorized_user.name}") }
			end

			describe "PreviousEvents/Index page for completed events" do

				let!(:old_event)	{ FactoryGirl.create(:event, product: product_1,
									start_date: Date.today - 30, end_date: Date.today - 20) }

				before { visit my_business_previous_events_path(founder_biz) }
				
				it { should have_content("The page you requested doesn't belong to you") }
				it { should have_title("#{non_authorized_user.name}") }
			end

			describe "Show page" do

				before { visit event_path(event) }
				
				it { should have_content("The page you requested doesn't belong to you") }
				it { should have_title("#{non_authorized_user.name}") }
			end

			describe "Edit page" do

				before { visit edit_event_path(event) }
				
				it { should have_title("#{non_authorized_user.name}") }
				it { should have_content("The page you requested doesn't belong to you") }
			end

			describe "New page" do

				before { visit new_my_business_event_path(founder_biz) }
				
				it { should have_title("#{non_authorized_user.name}") }
				it { should have_content("The page you requested doesn't belong to you") }
			end
		end

		describe "attempting to modify Event data" do

			before do
				sign_in non_authorized_user, no_capybara: true
				visit my_business_path(non_authorized_biz)
			end

				describe "Create" do

				let(:params) do
             		{ event: { 	product_id: product_1.id,
            						start_date: Date.today + 60,
            						end_date: Date.today + 67, 
            						created_by: 1  } }
           		end
          
           		it "should not create a new Event" do
             		expect do
               			post my_business_events_path(founder_biz, params)
            		end.not_to change(Event, :count)
           		end

           		describe "redirects to user home page" do

             		before { post my_business_events_path(founder_biz, params) }
             		
             		specify do
						expect(response).to redirect_to(user_path(non_authorized_user))
		    			expect(flash[:error]).to eq("Action not permitted!")
		    		end
           		end
         	end

         	describe "Update" do

           		let(:new_start_date)  { Date.today - 1 }
          		let(:params) do
            		{ event: { start_date: new_start_date } }
          		end
          
           		describe "should not modify the existing Event" do
            
             		before { patch event_path(event, params) } 
             		specify { expect(event.reload.start_date).not_to eq new_start_date }
           		end

           		describe "should redirect to root" do

             		before { patch event_path(event, params) }
             		
            		specify do
             			expect(response).to redirect_to(user_path(non_authorized_user))
		    			expect(flash[:error]).to eq("Action not permitted!")
		    		end
           		end             		
         	end

         	describe "Destroy" do

         		it "should not delete the existing Event" do
            		expect do
              			delete event_path(event)
            		end.not_to change(Event, :count)
          		end

          		describe "redirects to User home" do

            		before { delete event_path(event) }
            		
            		specify do
             			expect(response).to redirect_to(user_path(non_authorized_user))
		    			expect(flash[:error]).to eq("Action not permitted!")
		    		end
            	end
         	end
		end
	end
end
