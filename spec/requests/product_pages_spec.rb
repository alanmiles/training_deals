require 'spec_helper'

describe "ProductPages" do
  
  subject { page }

	before(:each) do 
 		Business.any_instance.stub(:geocode).and_return([1,1]) 
	end

	let!(:founder) 			{ FactoryGirl.create(:user) }
	let!(:administrator)	{ FactoryGirl.create(:user) }
	let!(:founder_biz)		{ FactoryGirl.create(:business, created_by: founder.id)}  #founder is automatically an owner
	let!(:other_biz)		{ FactoryGirl.create(:business, created_by: founder.id)}
	let!(:ownership_1)		{ FactoryGirl.create(:ownership, business: founder_biz, user: administrator,
								 email_address: administrator.email) }
	let!(:ownership_2)		{ FactoryGirl.create(:ownership, business: other_biz, user: administrator,
								 email_address: administrator.email) }
	let!(:method)			{ FactoryGirl.create(:training_method) }
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
	let!(:genre_2_cat_2_topic_1)	{ FactoryGirl.create(:topic, category: genre_2_cat_2, status: 1) }
	let!(:pending_topic)		{ FactoryGirl.create(:topic, category: genre_1_cat_1, status: 2 ) }

	describe "with no products defined" do

	  	describe "as business administrator" do

			before do 
				sign_in administrator
				visit my_business_path(founder_biz)  #sets session[:biz] and current_business
			end

			describe "visit the Index page" do

				before { visit my_business_products_path(founder_biz) }

				it { should have_title("Products & services") }
				it { should have_selector('h1', "Products & services")}
				it { should have_selector('h2', "for #{founder_biz.name}, #{founder_biz.city}") }
				it { should have_content("You now need to list all the training resources and programmes offered by your business.") }
				it { should have_link("<- Business details", href: my_business_path(founder_biz)) }
				it { should have_link("Add a product/service", href: new_my_business_product_path(founder_biz)) }
			end

			describe "visit the New page" do 

				describe "using Javascript" do

					before { visit new_my_business_product_path(founder_biz) }

			        it { should have_title("Add product/service") }
			        it { should have_selector('h1', "Add a product or service") }
			        it { should have_selector('h2', text: "for #{founder_biz.name}, #{founder_biz.city}") }
				    it { should have_link("<- Products/services intro", href: my_business_products_path(founder_biz))}    
					it { should have_content(founder_biz.currency_symbol) }

				    describe "Business menu" do  
			        	it { should have_link('Business home page', href: my_businesses_path) }
			        	it { should_not have_link('Schedules') }
			        		#'Schedules' excluded because no event-oriented products yet.
			        	it { should have_link('User home page', href: user_path(administrator)) }
			        end

			        describe "and create a new product" do

			        	describe "successfully" do

			        		before do
			        			find("#genre_genre_id").select("#{genre_1.description}")
			        			find("#topic_category_id").select("#{genre_1_cat_1.description}")
			        			find("#product_topic_id").select("#{genre_1_cat_1_topic_2.description}")
			        			fill_in 'Title', with: "Course_1"
			        			select "#{method.description}", from: 'product_training_method_id'
			        			fill_in 'Description', with: 'Description text'
			        			fill_in 'Benefits/results', with: 'Outcome text'
			        			select "#{length.description}"  , from: 'product_content_length_id'
			        			fill_in 'product_content_number', with: 5
			        			fill_in 'product_standard_cost', with: 99.99
			        		end

			        		it "should create a Product" do
			              		expect { click_button "Create" }.to change(founder_biz.products, :count).by(1) 
			            	end

			            	describe "and redirect to the Show page with correct data added" do

			            		before { click_button 'Create' }

			            		it { should have_title("Course_1") }
								it { should have_selector('h2', text: "#{founder_biz.name}, #{founder_biz.city}")}
								it { should have_selector('div.detail', 
									text: "#{genre_1.description} >> #{genre_1_cat_1.description} >> #{genre_1_cat_1_topic_2.description}") }
								it { should have_selector('div.detail', text: "No reference code entered") }
								it { should have_selector('div.detail', text: "#{method.description} - 5 #{length.description.downcase}s") }
								it { should have_selector('div.detail', text: "#{founder_biz.currency_symbol} 99.99") }
			            	end
			           
		        	end

			        	describe "unsuccessfully" do

			        		before { fill_in 'Title', with: "Incomplete course" }

			        		it "should not create a Product" do
			              		expect { click_button "Create" }.not_to change(founder_biz.products, :count) 
			            	end

			            	describe "and re-render the New page" do

			            		before { click_button 'Create' }

						        it { should have_selector('h1', "Add a product or service") }
						        it { should have_selector('h2', text: "for #{founder_biz.name}, #{founder_biz.city}") }
						        it { should have_content('error') }
			            	end
			        	end
			        end
			    end

			    describe "with Javascript disabled" do

			    	before { visit new_my_business_product_path(founder_biz) }

			    	it { should have_selector('h2.check-notice', text: "No Javascript!?") }
			    	it { should have_content("This page - and the whole HROOMPH application - works faster and better with Javascript") }

			    	describe "accept no-javascript option and redirect to Genre Selection page" do

			    		before { click_link "Continue without Javascript" }

			    		it { should have_title('Select genre') }
						it { should_not have_selector('h2', text: "Classification change") } #used for update only, not new
						it { should have_link('Back', new_my_business_product_path(founder_biz)) }
						it { should have_link('Business home page', href: my_businesses_path) }
			        	it { should have_link('Products', href: my_business_products_path(founder_biz)) }
			        	it { should have_link('User home page', href: user_path(administrator)) }
						it { should have_select('genre_id', text: genre_1.description) }
						it { should have_select('genre_id', text: genre_2.description) }
						it { should_not have_select('genre_id', text: pending_genre.description) }
						it { should_not have_select('genre_id', text: no_topic_genre.description) }
			        	
						describe "'Back' link redirects to New page" do

							before { click_link 'Back' }

							it { should have_selector('h2.check-notice', text: "No Javascript!?") }
						end

			        	describe "Select Genre and redirect to Select Category page" do

			        		before do
			        			find("#genre_id").select("#{genre_1.description}")
			        			click_button 'Confirm'
			        		end

			        		it { should have_title('Select category') }
    						it { should_not have_selector('h2', text: "Classification change") }   #only for update, not new
    						it { should have_selector('h2', "Genre selected: '#{genre_1.description}'") }
    						it { should have_link('Back to genre selection', new_genre_selection_path) }
    						it { should have_link('Business home page', href: my_businesses_path) }
				        	it { should have_link('Products', href: my_business_products_path(founder_biz)) }
				        	it { should have_link('User home page', href: user_path(administrator)) }
    						it { should have_select('category_id', text: genre_1_cat_1.description) }
 							it { should_not have_select('category_id', text: genre_2_cat_1.description) }
 							it { should_not have_select('category_id', text: genre_1_no_topic_cat.description) }
    					
 							describe "'Back' link redirects to Genre Selection page" do

 								before { click_link 'Back to genre selection' }

 								it { should have_title('Select genre') }
		        				it { should have_select('genre_id', selected: genre_1.description) }
 							end

 							describe "Select Category and redirect to Newprod page" do

 								before do
				        			find("#category_id").select("#{genre_1_cat_1.description}")
				        			click_button 'Confirm'
				        		end

				        		it { should have_title("Add product/service") }
				        		it { should have_selector('h1', "Add a product or service") }
			        			it { should have_selector('h2', text: "for #{founder_biz.name}, #{founder_biz.city}") }
								it { should have_content(founder_biz.currency_symbol) }	
								it { should have_link("<- Products/services intro", href: my_business_products_path(founder_biz))}    
					        	it { should have_link('Business home page', href: my_businesses_path) }
					        	it { should_not have_link('Schedules') }
					        		#'Schedules' excluded because no event-oriented products yet.
					        	it { should have_link('User home page', href: user_path(administrator)) }
					        	it { should have_selector('div.detail', text: genre_1.description) }
					        	it { should have_selector('div.detail', text: genre_1_cat_1.description) }
    							it { should have_select('product_topic_id', text: genre_1_cat_1_topic_1.description) }
    							it { should have_select('product_topic_id', text: genre_1_cat_1_topic_2.description) }
    							it { should_not have_select('product_topic_id', text: genre_2_cat_2_topic_1.description) }

    							describe "create a new Product" do

    								describe "successfully" do

    									before do
    										find("#product_topic_id").select("#{genre_1_cat_1_topic_2.description}")
    										fill_in 'Title', with: "Course_no_js"
						        			select "#{method.description}", from: 'product_training_method_id'
						        			fill_in 'Description', with: 'Description text'
						        			fill_in 'Benefits/results', with: 'Outcome text'
						        			select "#{length.description}"  , from: 'product_content_length_id'
						        			fill_in 'product_content_number', with: 5
						        			fill_in 'product_standard_cost', with: 99.99
						        		end

						        		it "should create a Product" do
						              		expect { click_button "Create" }.to change(founder_biz.products, :count).by(1) 
						            	end

						            	describe "and redirect to the Show page with correct data added" do

						            		before { click_button 'Create' }

						            		it { should have_title("Course_no_js") }
											it { should have_selector('h2', text: "#{founder_biz.name}, #{founder_biz.city}")}
											it { should have_selector('div.detail', 
												text: "#{genre_1.description} >> #{genre_1_cat_1.description} >> #{genre_1_cat_1_topic_2.description}") }
											it { should have_selector('div.detail', text: "No reference code entered") }
											it { should have_selector('div.detail', text: "#{method.description} - 5 #{length.description.downcase}s") }
											it { should have_selector('div.detail', text: "#{founder_biz.currency_symbol} 99.99") }
						            	end
    								end

    								describe "unsuccessfully" do

    									before { fill_in 'Title', with: "" }

    									it "should_not create a Product" do
						              		expect { click_button "Create" }.not_to change(founder_biz.products, :count).by(1) 
						            	end

						            	describe "and re-render the Newprod page with correct data added" do

						            		before { click_button 'Create' }

						            		it { should have_title("Add product/service") }
						        			it { should have_selector('h2', text: "for #{founder_biz.name}, #{founder_biz.city}") }
											it { should have_link("<- Products/services intro", href: my_business_products_path(founder_biz))}    
								        	it { should have_link('Business home page', href: my_businesses_path) }
								        	it { should_not have_link('Schedules') }
								        	it { should have_link('User home page', href: user_path(administrator)) }
								        	it { should have_selector('div.detail', text: genre_1.description) }
								        	it { should have_selector('div.detail', text: genre_1_cat_1.description) }
			    							it { should have_select('product_topic_id', text: genre_1_cat_1_topic_1.description) }
			    							it { should have_select('product_topic_id', text: genre_1_cat_1_topic_2.description) }
			    							it { should_not have_select('product_topic_id', text: genre_2_cat_2_topic_1.description) }
						            	end
    								end
    							end
 							end
    					end
			    	end
			    end
			end
		end
	end

	describe "with a single product defined" do

		let!(:single_product) { FactoryGirl.create(:product, business: other_biz,
			topic: genre_1_cat_1_topic_1, training_method: method, 
			content_length_id: length.id) }

		before do
			sign_in administrator
			visit my_business_path(other_biz)
		end

		describe "Index page" do

			before { visit my_business_products_path(other_biz) }

			it { should have_title("Products & services") }
			it { should have_link("details", href: product_path(single_product)) }

			it "should be able to delete the product and redirect correctly" do   #provided never scheduled
	            expect do
	              click_link('delete', href: product_path(single_product))
	            end.to change(Product, :count).by(-1)
	            expect(page).to have_title('Products & services')
	            expect(page).not_to have_selector('li', text: single_product.title)
	            expect(page).to have_content("You now need to list all the training 
	            		resources and programmes offered by your business.")
	        end
	    end
	end

	describe "with multiple products already defined" do

		let!(:other_biz_product) { FactoryGirl.create(:product, business: other_biz,
			topic: genre_1_cat_1_topic_1, training_method: method, 
			content_length_id: length.id) }
		let!(:product_1) { FactoryGirl.create(:product, business: founder_biz,
			topic: genre_1_cat_1_topic_1, training_method: method, 
			content_length_id: length.id) }
		let!(:product_2) { FactoryGirl.create(:product, business: founder_biz,
			topic: genre_1_cat_1_topic_2, training_method: method, 
			content_length_id: length.id) }
		let!(:delisted_product) { FactoryGirl.create(:product, business: founder_biz,
			topic: genre_1_cat_1_topic_2, training_method: method, 
			content_length_id: length.id, current: false) }
				
		describe "as business administrator" do

			before do 
				sign_in administrator
				visit my_business_path(founder_biz)
			end

			describe "visit the Index page" do

				before { visit my_business_products_path(founder_biz) }

				it { should have_title("Products & services") }
				it { should have_selector('h1', "Products & services")}
				it { should have_selector('h2', "for #{founder_biz.name}, #{founder_biz.city}") }
				it { should_not have_content("You now need to list all the training resources and programmes offered by your business.") }
				it { should have_link("<- Business details", href: my_business_path(founder_biz)) }
				it { should have_link("Add a product/service", href: new_my_business_product_path(founder_biz)) }
				it { should have_selector("li#product_#{product_1.id}", text: product_1.title) }
				it { should have_selector("li#product_#{product_2.id}", text: product_2.title) }
				it { should have_selector("li#product_#{delisted_product.id}", text: delisted_product.title) }
				it { should have_selector("li#product_#{delisted_product.id}", text: "No longer listed") }
				it { should_not have_selector("li#product_#{other_biz_product.id}", text: other_biz_product.title) }
				it { should have_link("details", href: product_path(product_1)) }
				it { should have_link('delete', href: product_path(product_2)) }   #provided no schedule

				pending "no delete link when associated activity / schedule"
				pending "TO ADD - list classification - ancestry, acts as tree? - to cope with longer lists"
			
				it "should be able to delete the product" do   #provided never scheduled
		            expect do
		              click_link('delete', href: product_path(product_1))
		            end.to change(Product, :count).by(-1)
		            expect(page).to have_title('Products & services') #another product exists
		            expect(page).not_to have_selector('li', text: product_1.title)
		            expect(page).to have_selector('li', text: product_2.title)
		        end
			end

			describe "visit the Show page" do

				describe "when not event-type" do
				
					before do
						visit my_business_path(other_biz)
						visit my_business_products_path(other_biz)
					  	click_link('details')
					end

					it { should have_title("#{other_biz_product.title}") }
					it { should have_selector('h1', text: "Product details") }
					it { should have_selector('h2', text: "#{other_biz.name}, #{other_biz.city}")}
					it { should have_link('Update', href: edit_product_path(other_biz_product)) }
					it { should have_link('<- All products/services', href: my_business_products_path(other_biz)) }
					it { should have_selector('div.detail', text: "#{other_biz_product.title}") }
					it { should have_selector('div.detail', 
						text: "#{genre_1.description} >> #{genre_1_cat_1.description} >> #{genre_1_cat_1_topic_1.description}") }
					it { should have_selector('div.detail', text: "No reference code entered") }
					it { should have_selector('div.detail', text: "#{method.description} - 5 modules") }
					it { should have_selector('div.detail', text: "#{other_biz_product.content}") }
					it { should have_selector('div.detail', text: "#{other_biz_product.outcome}") }
					it { should have_selector('div.detail', text: "#{other_biz.currency_symbol} 100") }
					it { should_not have_selector('div#qualification') }

					it { should_not have_content("NEXT SCHEDULED") }
					it { should_not have_content("NO SCHEDULED EVENTS") }

				end

				describe "when product is event-type" do

					let!(:event_method)			{ FactoryGirl.create(:training_method, 
													description: "Training course", event: true) }
					let!(:other_biz_event_product) { FactoryGirl.create(:product, business: other_biz,
							topic: genre_1_cat_1_topic_1, training_method: event_method, 
							duration_id: duration.id, duration_number: 1000,
							content_length_id: nil, content_number: nil) }

					describe "with no events scheduled" do

						before { visit product_path(other_biz_event_product) }

						it { should have_title("#{other_biz_event_product.title}") }
						it { should have_selector('h1', text: "Product details") }
						it { should have_selector('h5', text: "NO SCHEDULED EVENTS")}
					end

					describe "with 1 future event scheduled" do

						let!(:in_progress_event)	{ FactoryGirl.create(:event, product: other_biz_event_product,
							start_date: Date.today - 1, end_date: Date.today + 6) }
						let!(:new_event_1)	{ FactoryGirl.create(:event, product: other_biz_event_product,
							price: other_biz_event_product.standard_cost - 10) }

						before { visit product_path(other_biz_event_product) }

						it { should have_title("#{other_biz_event_product.title}") }
						it { should have_selector('h1', text: "Product details") }
						it { should have_content("NEXT SCHEDULED") }
						it { should_not have_selector('.js-toggle-list', text: "(show all..)") }
						it { should have_selector("li#event_#{new_event_1.id}", 
							text: "Price: #{other_biz.currency_symbol} #{other_biz_event_product.standard_cost - 10}") }
						it { should have_selector("li#event_#{new_event_1.id}", 
							text: "#{new_event_1.remaining_places} spaces") }
						it { should_not have_selector("li#event_#{in_progress_event.id}") }
					
						describe "edit Event from Product Show page" do

							before do 
								click_link "shortlist_#{new_event_1.id}"
								fill_in "Location", with: "Here"
								click_button "Update"
							end

							it { should have_title("#{other_biz_event_product.title}") }
							# i.e. redirecting to Product Show page rather than Event show page
						end

						describe "follow the Drop Changes link on Event Edit back to the Product page" do
	
							before do 
								click_link "shortlist_#{new_event_1.id}"
								fill_in "Location", with: "Here"
								click_link "<- Drop changes"
							end

							it { should have_title("#{other_biz_event_product.title}") }
							# i.e. redirecting to Product Show page rather than Event show page
						end
					end
					
					describe "with 4 future events scheduled" do

						let!(:new_event_1)	{ FactoryGirl.create(:event, product: other_biz_event_product,
							price: other_biz_event_product.standard_cost - 10) }

						let!(:new_event_2)	{ FactoryGirl.create(:event, product: other_biz_event_product,
							start_date: Date.today + 33, end_date: Date.today + 33, 
							price: other_biz_event_product.standard_cost, places_available: 16,
							places_sold: 16) }

						let!(:new_event_3)	{ FactoryGirl.create(:event, product: other_biz_event_product,
							start_date: Date.today + 43, end_date: Date.today + 50, 
							price: other_biz_event_product.standard_cost, places_available: 16,
							places_sold: 15) }

						let!(:new_event_4)	{ FactoryGirl.create(:event, product: other_biz_event_product,
							start_date: Date.today + 73, end_date: Date.today + 80, 
							price: other_biz_event_product.standard_cost) }

						before { visit product_path(other_biz_event_product) }

						it { should have_title("#{other_biz_event_product.title}") }
						it { should have_content("NEXT SCHEDULED") }
						it { should have_selector('.js-toggle-list', text: "(show all..)") }
						it { should_not have_selector("li#event_#{new_event_2.id}", text: "Price") }
						it { should_not have_selector("li#event_#{new_event_2.id}", 
							text: "#{formatted_shortdate(new_event_2.start_date)} - #{formatted_shortdate(new_event_2.end_date)}") }
						it { should have_selector("li#event_#{new_event_2.id}", 
							text: "#{formatted_shortdate(new_event_2.start_date)}") }
						it { should have_selector("li#event_#{new_event_2.id}", text: "Sold Out") }
						it { should have_selector("li#event_#{new_event_3.id}", 
							text: "#{new_event_3.remaining_places} space") }
						pending "Javscript show/reveal not tested for events list"

					end
				end
			end

			describe "visit the Edit page" do

				before do
					visit my_business_path(founder_biz)
					visit edit_product_path(product_2)
				end

				it { should have_title("Edit '#{product_2.title}'") } 
				it { should have_selector('h1', text: "Edit product details") }
				it { should have_selector('h2', text: "#{founder_biz.name}, #{founder_biz.city}")}
				it { should have_link('Cancel', href: product_path(product_2)) }

	        	it { should have_link('Business home page', href: my_businesses_path) }
	        	it { should have_link('Products', href: my_business_products_path(founder_biz)) }
	        	it { should have_link('User home page', href: user_path(administrator)) }
			        
	        	describe "and update the Product" do

	        		let!(:changed_title)			{ "Changed title" }
	        		describe "successfully" do

	        			describe "changing the classification" do

	        				describe "with javascript enabled" do
	        					before do
	        						find("#genre_genre_id").select("#{genre_2.description}")
		        					find("#topic_category_id").select("#{genre_2_cat_2.description}")
		        					find("#product_topic_id").select("#{genre_2_cat_2_topic_1.description}")
	        						click_button "Confirm"
		              			end

								it { should have_selector('h1', text: "Product details") }
								it { should have_selector('div.detail', 
									text: "#{genre_2.description} >> #{genre_2_cat_2.description} >> #{genre_2_cat_2_topic_1.description}") }
	        				end

	        				describe "with javascript disabled" do

	        					describe "redirect to the Select Genre page" do
	        					
	        						before { click_link '(change)' }

	        						it { should have_title('Select genre') }
	        						it { should have_selector('h2', "Classification change for '#{product_2.title}'") }
	        						it { should have_link('Back to product edit', edit_product_path(product_2)) }
	        						it { should have_link('Business home page', href: my_businesses_path) }
						        	it { should have_link('Products', href: my_business_products_path(founder_biz)) }
						        	it { should have_link('User home page', href: user_path(administrator)) }
	        						it { should have_select('genre_id', selected: genre_1.description) }
						        	
						        	describe "Select genre and redirect to Select Category page" do

						        		before do
						        			find("#genre_id").select("#{genre_2.description}")
						        			click_button 'Confirm'
						        		end

						        		it { should have_title('Select category') }
		        						it { should have_selector('h2', "Classification change for '#{product_2.title}'") }
		        						it { should have_selector('h2', "Genre selected: '#{genre_2.description}'") }
		        						it { should have_link('Back to genre selection', new_genre_selection_path) }
		        						it { should have_link('Business home page', href: my_businesses_path) }
							        	it { should have_link('Products', href: my_business_products_path(founder_biz)) }
							        	it { should have_link('User home page', href: user_path(administrator)) }
		        						#it { should have_select('category_id', selected: genre_2_cat_2.description) }

		        						describe "return to Genre Selection page" do

		        							before { click_link "Back to genre selection" }

		        							it { should have_title('Select genre') }
		        							it { should have_select('genre_id', selected: genre_2.description) }
		        						end

		        						describe "Select category and continue to Topic Selector page" do

		        							before do
							        			find("#category_id").select("#{genre_2_cat_2.description}")
							        			click_button 'Confirm'
							        		end

						        			it { should have_title('Select topic') }
			        						it { should have_selector('h2', "Classification change for '#{product_2.title}'") }
			        						it { should have_selector('h2', "Genre: #{genre_2.description} >> Category: #{genre_2_cat_2.description}") }
			        						it { should have_link('Back to category selection', new_category_selection_path) }
			        						it { should have_link('Business home page', href: my_businesses_path) }
								        	it { should have_link('Products', href: my_business_products_path(founder_biz)) }
								        	it { should have_link('User home page', href: user_path(administrator)) }

								        	describe "return to Category Selection page" do

			        							before { click_link "Back to category selection" }

			        							it { should have_title('Select category') }
			        							it { should have_select('category_id', selected: genre_2_cat_2.description) }
			        						end

			        						describe "select topic and return to main Edit page" do

			        							before do
								        			find("#topic_id").select("#{genre_2_cat_2_topic_1.description}")
								        			click_button 'Confirm'
								        		end

								        		it { should have_title("Edit '#{product_2.title}'") } 
								        		it { should have_content("#{genre_2.description} >> #{genre_2_cat_2.description} >> #{genre_2_cat_2_topic_1.description}") }

			        						end        		
		        						end
						        	end
	        					end
	        				end
	        			end

	        			describe "keeping the classification but changing other details" do

	        				before do
        						fill_in 'Title', with: changed_title
        						fill_in 'Our reference code', with: "xxx-000"
        						fill_in 'Qualification', with: 'A qualification'
        						select 'Not specified', from: 'product_content_length_id'
        						fill_in 'product_content_number', with: ""
        						select "#{duration.time_unit}", from: 'product_duration_id'
        						fill_in 'product_duration_number', with: 1
        						click_button "Confirm"
	              			end

	              			it { should have_title("#{changed_title}") }
							it { should have_selector('h1', text: "Product details") }
							it { should_not have_selector('div.detail', text: "No reference code entered") }
							it { should have_content("xxx-000") }
							it { should have_selector('div#qualification') }
							it { should have_selector('div.detail', text: "#{method.description} - 1 #{duration.time_unit.downcase}") }
			              	specify { expect(product_2.reload.title).to eq changed_title }
	        			end
	        		end

	        		describe "unsuccessfully" do

	        		end
	        	end
			end

			describe "visit the New page" do

				before { visit new_my_business_product_path(founder_biz) }

		        it { should have_title("Add product/service") }
			    it { should have_link("<- All products/services", href: my_business_products_path(founder_biz))} 
			end
		end

		describe "when not signed in" do

			describe "Index" do
				
				describe "redirect to the signin page" do
				
					before { get my_business_products_path(other_biz) }
					inaccessible_without_signin
				end

				describe "go to correct Index page after signing in" do

					before do
						visit my_business_products_path(other_biz)
						valid_signin(founder)
					end
					
					specify do
						expect(page).to have_title('Products & services')
						expect(page).to have_selector('h2', "for #{other_biz.name}, #{other_biz.city}")
						expect(page).to have_selector("li#product_#{other_biz_product.id}", text: other_biz_product.title)
					end

					describe "but don't go to this index page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in founder
						end	

						specify { expect(page).not_to have_title('Products & services') }
					end
				end
			end

			describe "Show" do

				before { get product_path(product_2) }
				inaccessible_without_signin

				describe "go to correct Show page after signing in" do

					before do
						visit product_path(product_2)
						valid_signin(founder)
					end
					
					specify do
						expect(page).to have_title("#{product_2.title}")
						expect(page).to have_selector('div.detail', 
						    "#{genre_1.description} >> #{genre_1_cat_1.description} >> #{genre_1_cat_1_topic_2.description}")
					end

					describe "but don't go to this Show page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in founder
						end	

						specify { expect(page).not_to have_title("#{product_2.title}") }
					end
				end
			end

			describe "Edit" do

				before { get edit_product_path(other_biz_product) }
				inaccessible_without_signin

				describe "go to correct Edit page after signing in" do

					before do
						visit edit_product_path(other_biz_product)
						valid_signin(administrator)
					end
					
					specify { expect(page).to have_title("Edit '#{other_biz_product.title}'") }
		

					describe "but don't go to this Edit page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in administrator
						end	

						specify { expect(page).not_to have_title("Edit '#{other_biz_product.title}'") }
					end
				end
			end

			describe "New" do

				before { get new_my_business_product_path(founder_biz) }
				inaccessible_without_signin

				describe "go to correct New page after signing in" do

					before do
						visit new_my_business_product_path(founder_biz)
						valid_signin(administrator)
					end
					
					specify do
						expect(page).to have_title("Add product/service")
			    		expect(page).to have_link("<- All products/services", href: my_business_products_path(founder_biz))
						expect(page).to have_selector("input#product_created_by[value=\"#{administrator.id}\"]")
						# NOTE: Capybara set to handle hidden fields in spec_helper
					end

					describe "but don't go to this New page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in administrator
						end	

						specify { expect(page).not_to have_title('Add business') }
					end
				end
			end

			describe "attempting to manipulate data" do

				describe "Create" do

              		let(:params) do
                		{ product: { 	business_id: founder_biz.id,
                						title: "Illegal",
                						topic_id: genre_1_cat_1_topic_1, 
                						training_method_id: method.id,
                						content_number: 5,
                						content_length_id: length.id,
                						currency: "GBP",
                						standard_cost: 100.00,
                						content: "Course content",
                						outcome: "Course outcome",
                						created_by: 1  } }
              		end
              
              		it "should not create a new Product" do
                		expect do
                  			post my_business_products_path(founder_biz, params)
                		end.not_to change(Product, :count)
              		end

              		describe "should redirect to root" do

                		before { post my_business_products_path(founder_biz, params) }
                		forbidden_without_signin
              		end
            	end

            	describe "Update" do

              		let(:new_product_title)  { "Changed title"}
              		let(:params) do
                		{ product: { title: new_product_title } }
              		end
              
              		describe "should not modify the existing product" do
                
                		before { patch product_path(product_1), params } 
                		specify { expect(product_1.reload.title).not_to eq new_product_title }
              		end

              		describe "should redirect to root" do

                		before { patch product_path(product_1, params) }
                		forbidden_without_signin
              		end
            	end

            	describe "Destroy" do

              		it "should not delete the existing Product" do
                		expect do
                  			delete product_path(product_1)
                		end.not_to change(Product, :count)
              		end

              		describe "should redirect to root" do

                		before { delete product_path(product_1) }
                		forbidden_without_signin
                	end
              	end
			end
		end

		describe "when user is not a business owner" do

			let!(:non_authorized_user)	{ FactoryGirl.create(:user) }
			let!(:non_authorized_biz)	{ FactoryGirl.create(:business, created_by: non_authorized_user.id)} 

			describe "displaying forms" do
				before do
					sign_in non_authorized_user
					visit my_business_path(non_authorized_biz)
				end

				describe "Index page" do

					before { visit my_business_products_path(other_biz) }
					
					it { should have_content("The page you requested doesn't belong to you") }
					it { should have_title("#{non_authorized_user.name}") }
				end

				describe "Show page" do

					before { visit product_path(product_2) }
					
					it { should have_content("The page you requested doesn't belong to you") }
					it { should have_title("#{non_authorized_user.name}") }
				end

				describe "Edit page" do

					before { visit edit_product_path(other_biz_product) }
					
					it { should have_title("#{non_authorized_user.name}") }
					it { should have_content("The page you requested doesn't belong to you") }
				end

				describe "New page" do

					before { visit new_my_business_product_path(founder_biz) }
					
					it { should have_title("#{non_authorized_user.name}") }
					it { should have_content("The page you requested doesn't belong to you") }
				end
			end

			describe "attempting to modify Product data" do

				before do
					sign_in non_authorized_user, no_capybara: true
					visit my_business_path(non_authorized_biz)
				end

  				describe "Create" do

    				let(:params) do
                 		{ product: { 	business_id: founder_biz.id,
                						title: "Illegal",
                						topic_id: genre_1_cat_1_topic_1.id, 
                						training_method_id: method.id,
                						content_number: 5,
                						content_length_id: length.id,
                						currency: "GBP",
                						standard_cost: 100.00,
                						content: "Course content",
                						outcome: "Course outcome",
                						created_by: 1  } }
               		end
              
               		it "should not create a new product" do
                 		expect do
                   			post my_business_products_path(founder_biz, params)
                		end.not_to change(Product, :count)
               		end

               		describe "redirects to user home page" do

                 		before { post my_business_products_path(founder_biz, params) }
                 		
                 		specify do
							expect(response).to redirect_to(user_path(non_authorized_user))
			    			expect(flash[:error]).to eq("Action not permitted!")
			    		end
               		end
             	end

             	describe "Update" do

	           		let(:new_title)  { "New Title"}
               		let(:params) do
                		{ product: { title: new_title } }
               		end
              
               		describe "should not modify the existing Product" do
                
                 		before { patch product_path(product_1, params) } 
                 		specify { expect(product_1.reload.title).not_to eq new_title }
               		end

               		describe "should redirect to root" do

                 		before { patch product_path(product_1, params) }
                 		
                		specify do
                 			expect(response).to redirect_to(user_path(non_authorized_user))
			    			expect(flash[:error]).to eq("Action not permitted!")
			    		end
               		end             		
             	end

             	describe "Destroy" do

             		it "should not delete the existing Product" do
                		expect do
                  			delete product_path(product_1)
                		end.not_to change(Product, :count)
              		end

              		describe "redirects to User home" do

                		before { delete product_path(product_1) }
                		
                		specify do
                 			expect(response).to redirect_to(user_path(non_authorized_user))
			    			expect(flash[:error]).to eq("Action not permitted!")
			    		end
                	end
             	end
  			end
		end
	end
end
