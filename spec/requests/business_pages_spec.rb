require 'spec_helper'

describe "BusinessPages" do
  subject { page }

  	before(:each) do
 		Business.any_instance.stub(:geocode).and_return([1,1]) 
	end
  	
  	describe "dealing with the user's own businesses (My Businesses)" do

	  	describe "signed in" do   
	  
	  		let(:user) { FactoryGirl.create(:user) }
	  		let(:other_user) { FactoryGirl.create(:user) }
	  		before { sign_in user }

	  		describe "with no existing businesses" do

	  			describe "Index page" do 

		  			before { visit my_businesses_path }

		            it { should have_title('Your business: getting started') }
		            it { should have_content('Your business: getting started') }
		            it { should have_link('Add your training business now!', href: new_my_business_path) }

		            describe "Business menu" do  #minimized with no businesses
			        	it { should_not have_link('Business home page', href: my_businesses_path) }
			        	it { should_not have_link('Products') }
			        	it { should have_link('User home page', href: user_path(user)) }
			        end

		            describe "follow the 'Add new' link" do

		            	before { click_link "Add your training business now!" }

		            	it { should have_link('Business home page', href: my_businesses_path) }
		            	it { should have_link('User home page', href: user_path(user)) }
		            	it { should_not have_content("Is your business involved in improving people's skills") }
		            	# Info sidebar not used until users have entered their first business because
		            	# the content is same as the Getting Started page
		            end
		        end
	  		end

	  		describe "with one existing business" do
	  			let!(:business_1) 	{ FactoryGirl.create(:business, created_by: user.id) }

	  			describe "Index action should redirect to 'Show' page" do
	  			
		  			before { visit my_businesses_path }
		  			#redirect to 'Show' page

		  			it { should have_title("#{business_1.name}, #{business_1.city}") }
		  			it { should have_link("Add another business ->", href: new_my_business_path) }
		  			it { should_not have_link("<- My business list", my_businesses_path) }
		  		
		  			describe "Business menu" do  #full on 'Show' page
			        	it { should have_link('Business home page', href: my_businesses_path) }
			        	it { should have_link('Products', href: my_business_products_path(business_1)) }
			        	it { should have_link('User home page', href: user_path(user)) }
			        end

		  			it "should be able to delete the businesses" do   #provided no user activity yet
			            expect do
			              click_link('Delete the business ->', href: my_business_path(business_1))
			            end.to change(Business, :count).by(-1)
			            expect(page).to have_title('Your business: getting started') #no other businesses
			            expect(page).not_to have_selector('li', text: business_1.name)
			        end
		  		end
	  		end

	    	describe "with more than 1 existing business" do

	          	let!(:business_1) 	{ FactoryGirl.create(:business, created_by: user.id) }
	          	let!(:business_2) 	{ FactoryGirl.create(:business, created_by: user.id) }
	          	let!(:other_user_business) {FactoryGirl.create(:business, created_by: other_user.id) }

	          	describe "Index page" do

		          	before { visit my_businesses_path }

		            it { should have_title('My businesses') }
		            it { should have_content('My businesses') }
		            it { should have_selector('li', text: business_1.name) }
		            it { should have_selector('li', text: business_1.city) }
		            it { should have_selector('li', text: business_1.country) }
		            it { should have_selector('li', text: business_2.name) }
		            it { should_not have_selector('li', text: other_user_business.name) } #only own businesses
		            it { should have_link('select', href: my_business_path(business_1)) }
		            it { should have_link('delete', href: my_business_path(business_1)) }
		            it { should have_link('Add a business', href: new_my_business_path) }
			        
			        describe "minimized Business menu" do #no business selected
			        	it { should_not have_link('Business home page', href: my_businesses_path) }
			        	it { should_not have_link('Products') }
			        	it { should_not have_link('Schedules', href: "#") }
			        	it { should_not have_link('* Promotions *', href: "#") }
			        	it { should_not have_link('Reviews', href: "#") }
			        	it { should_not have_link('History', href: "#") }
			        	it { should_not have_link('Account', href: "#") }
			        	it { should have_link('User home page', href: user_path(user)) }
			        end

			        pending "No delete link when the business has a history"
			        pending "Has a 'deactivated' field if the business has been de-activated by the user"

			        describe "follow the 'Add new' link" do

		            	before { click_link "Add a business" }

		            	it { should have_link('Business home page', href: my_businesses_path) }
		            	it { should have_content("Is your business involved in improving people's skills") }
		            end

			     	it "should be able to delete one of two owned businesses" do   #provided no user activity yet
			            expect do
			              click_link('delete', href: my_business_path(business_1))
			            end.to change(Business, :count).by(-1)
			            expect(page).to have_title("#{business_2.name}, #{business_2.city}")
			            expect(page).to have_content("#{business_1.name}, #{business_1.city} deleted. This is your only training business now.")
			            #expect(page).to have_title('Your business: getting started') #no other businesses
			            #expect(page).not_to have_selector('li', text: business_1.name)
			        end

			        it "should delete the associated Ownership record" do
			        	expect do
			              click_link('delete', href: my_business_path(business_1))
			            end.to change(Ownership, :count).by(-1)
			        end

			        it "should not delete associated Users" do
			        	expect do
			              click_link('delete', href: my_business_path(business_1))
			            end.not_to change(User, :count)
			        end

			        pending "should not be able to delete if user history associated"
		    	end
		    end

		    describe "with 3 or more businesses" do

		    	let!(:business_1) 	{ FactoryGirl.create(:business, created_by: user.id) }
	          	let!(:business_2) 	{ FactoryGirl.create(:business, created_by: user.id) }
	          	let!(:business_3) 	{ FactoryGirl.create(:business, created_by: user.id) }
		    
	          	describe "deleting a business" do

	          		before { visit my_businesses_path }

	          		describe "Business menu" do  #minimized with no business selected
			        	it { should_not have_link('Business home page', href: my_businesses_path) }
			        	it { should_not have_link('Products') }
			        	it { should have_link('User home page', href: user_path(user)) }
			        end

	          		it "should redirect to the Index page" do   #provided no user activity yet
			            expect do
			              click_link('delete', href: my_business_path(business_1))
			            end.to change(Business, :count).by(-1)
			            expect(page).to have_title("My businesses")
			            expect(page).to have_content("#{business_1.name} in #{business_1.city} deleted.")
			        end
	          	end
		    end

		    describe "visit the New page" do

		    	let!(:business_1) 	{ FactoryGirl.create(:business, created_by: user.id) }
		    	#so that new business is second owned by the user

		        before { visit new_my_business_path }

		        it { should have_title("Add business") }
		        it { should have_content("Add a business") }
		        it { should have_link("<- Cancel", href: my_businesses_path) }
		        it { should have_unchecked_field("business_hide_address") }
		        it { should have_content("Check the box to hide your address from other users") }
		        it { should_not have_content("Check the box if you no longer want users to see this business") }
		        it { should_not have_unchecked_field("business_inactive") }

		        describe "Business menu" do  #only for 'New' page
		        	it { should have_link('Business home page', href: my_businesses_path) }
		        	it { should_not have_link('Products') }
		        	it { should have_link('User home page', href: user_path(user)) }
		        end

		        describe "then create a new Business successfully" do
		            before do
		               	fill_in "Business name",    			with: "Business X"
		               	fill_in "Street address",	with: "1 Old Street"
		               	fill_in "Town/city",		with: "London"
		               	fill_in "Post/zip code", 	with: "EC1V 9HL"
		               	fill_in "Phone",			with: "071-456-7890"
		               	fill_in "Email",			with: "new_business@example.com"
		               	fill_in "Description",		with: "An exciting new business"
		               	#country is default "United Kingdom"
		            end

		            it "should create a Business" do
		              	expect { click_button "Create" }.to change(Business, :count).by(1) 
		            end

		            it "should create a new Ownership record" do
		            	expect { click_button "Create" }.to change(Ownership, :count).by(1) 
		            end

		            describe "and redirect to the Show page" do
		              	before { click_button 'Create' }

		              	it { should have_title('Business X, London') }
		              	it { should have_link('( details )', href: my_business_ownerships_path(Business.last))}
		              	it { should have_link('Update', href: edit_my_business_path(Business.last)) } 
		              	it { should have_selector('div.alert.alert-success', 
		              		text: "Successfully added. Please check all the details carefully.") }
		              	it { should_not have_selector('div.check-notice', 
		              		text: "Please check this address.") }  
		            end
		        end

		        describe "then create a business successfully - but without geocoding" do

		        	before do
		               	fill_in "Business name",    with: "Non-geocoded business"
		               	fill_in "Street address",	with: "2 Old Street"
		               	fill_in "Town/city",		with: "Moscow"
		               	select "France",			from: "Country"
		               	fill_in "Phone",			with: "071-456-7890"
		               	fill_in "Email",			with: "nongeocoded@example.com"
		               	fill_in "Description",		with: "A non--geocoded business"
		            end

		            it "should create a Business" do
		              	expect { click_button "Create" }.to change(Business, :count).by(1) 
		            end

		            describe "and redirect to the Show page" do
		              	before { click_button 'Create' }

		              	it { should have_title('Non-geocoded business, Moscow') }
 
		              	it { should have_selector('div.check-notice', 
		              		text: "Please check this address") } 
		            
		              	describe "with error warning on index page" do

			            	#let(:latest_business) { Business.last }
			            	let(:latest_business) { Business.find_by(name: "Non-geocoded business") }
			            	before { visit my_businesses_path }

			            	it { should have_selector("li#business_#{latest_business.id}", 
			            			text: "* Check details") }
			            end
		            end  
		        end

		        describe "then fail to create a new Business successfully" do
		            
		            it "should not create a Business" do    #no parameters
		              	expect { click_button 'Create' }.not_to change(Business, :count)
		            end

		            it "should not create a new Ownership record" do
		            	expect { click_button 'Create' }.not_to change(Ownership, :count)
		            end

		            describe "continue to show the New page with an error message" do

		             	before do
		                	fill_in "Business name",    with: "   "
		                	click_button "Create"
		              	end
		            
		              	it { should have_title('Add business') }
		              	it { should have_content('error') }

		              	describe "Business menu" do  #correct for 'New' page
				        	it { should have_link('Business home page', href: my_businesses_path) }
				        	it { should_not have_link('Products') }
				        	it { should have_link('User home page', href: user_path(user)) }
				        end
		            end
		        end
		    end

		    describe "visit the Edit page" do

		        let!(:changed_business) { FactoryGirl.create(:business, created_by: user.id) }
		        let!(:hidden_address_business) { FactoryGirl.create(:business, 
		        		hide_address: true, created_by: user.id) }
		        let!(:inactive_business) { FactoryGirl.create(:business, hide_address: true,
		        		inactive: true, inactive_from: Date.today - 2.days, created_by: user.id) }

		        before { visit edit_my_business_path(changed_business) }

	          	it { should have_title('Edit business') }
	          	it { should have_content('Edit business') }
	          	it { should have_link('<- Cancel', href: my_business_path(changed_business)) }
	          	it { should have_unchecked_field("business_hide_address") }
		        it { should have_content("Check the box to hide your address from other users") }
		        it { should have_content("Check the box if you no longer want users to see this business") }
		        it { should have_unchecked_field("business_inactive") }
		        it { should have_selector("input#business_inactive_from", visible: false) }

		        describe "Business menu" do
		        	it { should have_link('Business home page', href: my_businesses_path) }
		        	it { should have_link('Products', my_business_products_path(changed_business)) }
		        	it { should have_link('Schedules', href: "#") }
		        	it { should have_link('* Promotions *', href: "#") }
		        	it { should have_link('Reviews', href: "#") }
		        	it { should have_link('History', href: "#") }
		        	it { should have_link('Account', href: "#") }
		        	it { should have_link('User home page', href: user_path(user)) }
		        end

		        describe "and update the Business" do

		            let(:old_name) { changed_business.name}
		            describe "succesfully" do

		              	let(:new_name)   { "New Name" }
		              	before do
		                	fill_in "Business name",    with: new_name
		                	click_button "Confirm"
		              	end

		              	it { should have_title("#{new_name}, #{changed_business.city}") }
		              	it { should have_selector('div.alert.alert-success', text: "'New Name' updated") }
		              	specify { expect(changed_business.reload.name).to eq new_name }


		              	describe "revealing contents of the Show page" do
		              		it { should have_selector('h1', text: "Business details") }
		              		it { should have_selector('div.present', text: "#{new_name}") }
		              		it { should have_selector('div.detail', text: new_name) }
		              		it { should have_selector('div.detail', 
		              			text: "#{changed_business.street_address}") }
		              		it { should have_selector('div.detail', "Not shown") }    #i.e. no phone
		              		it { should have_selector('div.detail', "#{changed_business.email}") }
		              		it { should have_selector('div.detail', "#{changed_business.description}") }
		              		it { should_not have_selector("span.check-notice", "- Hidden from users") }
		              	end
		            end

		            describe "unsuccessfully" do

		            	before do
		                	fill_in "Business name",    with: "  "
		                	click_button "Confirm"
		              	end

		              	it { should have_title('Edit business')}
		              	it { should have_content('error') }
		              	specify { expect(changed_business.reload.name).to eq old_name }
		            end
		        end

		        describe "and make the business inactive setting correct Inactive_From date" do

		        	before do
		        		check "De-activate"
		        		click_button "Confirm"
		        	end

		        	it { should have_selector('div.check-notice', 
		        		text: "You deactivated this business on #{Time.now.strftime('%b %d, %Y')}") }
		        
		        	describe "then reactivate the business and cancel Inactive_From date" do

		        		before do
		        			click_link "Update ->"
		        			uncheck "De-activate"
		        			click_button "Confirm"
		        		end

		        		specify { expect(changed_business.reload.inactive_from).to eq nil }
		        	end
		        end

		        describe "when hide_address is checked" do

		        	before { visit edit_my_business_path(hidden_address_business) }

		        	it { should have_checked_field("business_hide_address") }
			        it { should have_content("Uncheck the box to reveal your address to other users") }
			        
			        describe "'Hidden address' alert on Show page" do

			        	before { click_link "<- Cancel" }

			        	it { should have_title("#{hidden_address_business.name}, #{hidden_address_business.city}") }
			        	it { should have_selector("span.check-notice", "- Hidden from users") }
			        	it { should_not have_selector("div.check-notice", "You deactivated this business on") }

			        	describe "as well as 'Hidden address' alert on Index page" do

			        		before { click_link "<- My business list" }

			        		it { should have_title("My businesses") }
			        		it { should have_selector('li', text: hidden_address_business.name) }
			        		it { should have_selector("li#business_#{hidden_address_business.id}", 
			        				text: "* Address hidden from users") }
			        		it { should_not have_selector("li#business_#{hidden_address_business.id}", 
			        				text: "* Inactive business") }
			        	end
			        end
		        end

		        describe "when inactive is checked" do

		        	before { visit edit_my_business_path(inactive_business) }
		        
		        	it { should have_content("Uncheck the box if you want to reactivate this business again") }
			        it { should have_checked_field("business_inactive") }

			        describe "'Inactive' alert on Show page" do

			        	before { click_link "<- Cancel" }

			        	it { should have_title("#{inactive_business.name}, #{inactive_business.city}") }
			        	it { should have_selector("div.check-notice", "You deactivated this business on") }
			        	it { should_not have_selector("span.check-notice", "- Hidden from users") }

			        	describe "as well as 'Inactive' alert on Index page" do

			        		before { click_link "<- My business list" }

			        		it { should have_title("My businesses") }
			        		it { should have_selector('li', text: inactive_business.name) }
			        		it { should have_selector("li#business_#{inactive_business.id}", 
			        				text: "* Inactive business") }
			        		it { should_not have_selector("li#business_#{inactive_business.id}", 
			        				text: "* Address hidden from users") }
			        	end
			        end
		        end
		    end
	    end
	end

	describe "unauthorized access" do

		let!(:user) { FactoryGirl.create(:user) }
		let!(:second_user) { FactoryGirl.create(:user, name: "Second User", email: "seconduser@example.com") }
		let!(:unauthorized_business) 	{ FactoryGirl.create(:business, created_by: user.id) }
		let!(:second_user_business) 	{ FactoryGirl.create(:business, created_by: second_user.id) }
		let!(:second_user_business_2) 	{ FactoryGirl.create(:business, created_by: second_user.id) }

		describe "not signed in" do

			describe "Index" do
				
				describe "redirect to the signin page" do
				
					before { get my_businesses_path }
					inaccessible_without_signin
				end

				describe "go to correct Index page after signing in" do

					before do
						visit my_businesses_path
						valid_signin(second_user)
					end
					
					specify do
						expect(page).to have_title('My businesses')
						expect(page).to have_selector('li', text: second_user_business.name)
					end

					describe "but don't go to this index page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in second_user
						end	

						specify { expect(page).not_to have_title('My businesses') }
					end
				end
			end

			describe "Show" do

				before { get my_business_path(unauthorized_business) }
				inaccessible_without_signin

				describe "go to correct Show page after signing in" do

					before do
						visit my_business_path(unauthorized_business)
						valid_signin(user)
					end
					
					specify do
						expect(page).to have_title("#{unauthorized_business.name}, #{unauthorized_business.city}")
						expect(page).to have_content("#{unauthorized_business.full_address}")
					end

					describe "but don't go to this Show page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in user
						end	

						specify { expect(page).not_to have_title("#{unauthorized_business.name}, #{unauthorized_business.city}") }
					end
				end

				describe "don't allow unauthorized users to view Show page" do

					before do
						visit my_business_path(unauthorized_business)
						valid_signin(second_user)
					end
					
					it { should have_content("The page you requested doesn't belong to you") }
					it { should have_title("#{second_user.name}") }
				end
			end

			describe "Edit" do

				before { get edit_my_business_path(unauthorized_business) }
				inaccessible_without_signin

				describe "go to correct Edit page after signing in" do

					before do
						visit edit_my_business_path(unauthorized_business)
						valid_signin(user)
					end
					
					specify { expect(page).to have_title("Edit business") }
		

					describe "but don't go to this Edit page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in user
						end	

						specify { expect(page).not_to have_title("Edit business") }
					end
				end

				describe "don't allow unauthorized users to view Show page" do

					before do
						visit edit_my_business_path(unauthorized_business)
						valid_signin(second_user)
					end
					
					it { should have_title("#{second_user.name}") }
					it { should have_content("The page you requested doesn't belong to you") }
				end
			end

			describe "New" do

				before { get new_my_business_path }
				inaccessible_without_signin

				describe "go to correct New page after signing in" do

					before do
						visit new_my_business_path
						valid_signin(second_user)
					end
					
					specify do
						expect(page).to have_title('Add business')
						expect(page).to have_selector("input#business_created_by[value=\"#{second_user.id}\"]")
						# NOTE: Capybara set to handle hidden fields in spec_helper
					end

					describe "but don't go to this New page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in second_user
						end	

						specify { expect(page).not_to have_title('Add business') }
					end
				end
			end

			describe "attempting to manipulate the Business data" do
	            
            	describe "Create" do

              		let(:params) do
                		{ my_business: { name: "Newbiz",
                						description: "Newbiz desc", 
                						street_address: "23 Pembroke Street",
                						city: "Salford",
                						state: "Greater Manchester",
                						country: "England",
                						email: "newbiz@example.com" } }
              		end
              
              		it "should not create a new Business" do
                		expect do
                  			post my_businesses_path(params)
                		end.not_to change(Business, :count)
              		end

              		describe "should redirect to root" do

                		before { post my_businesses_path(params) }
                		forbidden_without_signin
              		end
            	end

            	describe "Update" do

              		let(:new_business_name)  { "Changed business"}
              		let(:params) do
                		{ business: { name: new_business_name } }
              		end
              
              		describe "should not modify the existing business" do
                
                		before { patch my_business_path(unauthorized_business), params } 
                		specify { expect(unauthorized_business.reload.name).not_to eq new_business_name }
              		end

              		describe "should redirect to root" do

                		before { patch my_business_path(unauthorized_business), params }
                		forbidden_without_signin
              		end
            	end

            	describe "Destroy" do

              		it "should not delete the existing Business" do
                		expect do
                  			delete my_business_path(unauthorized_business)
                		end.not_to change(Business, :count)
              		end

              		describe "should redirect to root" do

                		before { delete my_business_path(unauthorized_business) }
                		forbidden_without_signin
                	end
              	end
          	end
		end

		describe "signed in but not as an owner of the specified business" do

			before do
				sign_in second_user, no_capybara: true
			end

			describe "Show page" do
				
				before { get my_business_path(unauthorized_business) }
			
				specify do
					expect(response).to redirect_to user_path(second_user)
    				expect(flash[:error]).to eq("The page you requested doesn't belong to you!")
    			end
			end

			describe "Edit page" do

				before { get edit_my_business_path(unauthorized_business) }
		
				specify do
					expect(response).to redirect_to user_path(second_user)
    				expect(flash[:error]).to eq("The page you requested doesn't belong to you!")
    			end
			end

			describe "attempting to modify Business data" do

				describe "Update" do

					let(:params) do
                		{ unauthorized_business: { name: "NewName" } }
              		end
              		
              		before do
              			patch my_business_path(unauthorized_business), params
              		end 

              		specify do
						expect(response).to redirect_to(user_path(second_user))
			    		expect(flash[:error]).to eq("Action not permitted!")
			    	end
				end

				describe "Destroy" do

					before { delete my_business_path(unauthorized_business) }

					specify do
						expect(response).to redirect_to(user_path(second_user))
			    		expect(flash[:error]).to eq("Action not permitted!")
			    	end
				end
			end
		end
	end

	describe "Listed as joint business administrator" do

		let!(:founder) 		{ FactoryGirl.create(:user) }
		let!(:team_member)	{ FactoryGirl.create(:user) }
		let!(:founder_biz)	{ FactoryGirl.create(:business, created_by: founder.id) }
		let!(:second_biz)	{ FactoryGirl.create(:business, created_by: founder.id) }
		let!(:third_biz)	{ FactoryGirl.create(:business, created_by: founder.id) }
		let!(:second_owner)	{ FactoryGirl.create(:ownership, 
						business: founder_biz,
						user: team_member,
						email_address: team_member.email,
						created_by: founder.id) }
		let!(:second_owner_third_biz)	{ FactoryGirl.create(:ownership, 
						business: third_biz,
						user: team_member,
						email_address: team_member.email,
						created_by: founder.id) }


		before { sign_in team_member }

		describe "can see all businesses where a team member in My Businesses index" do
			before { visit my_businesses_path }

			it { should have_title("My businesses") }
			it { should have_selector('li', text: founder_biz.name) }
			it { should_not have_selector('li', text: second_biz.name) }
	            
	     	describe "when current_user has only businesses" do
	     		
	     		it "should be able to delete a business" do   #provided no user activity yet
		            expect do
		              click_link('delete', href: my_business_path(founder_biz))
		            end.to change(Business, :count).by(-1)
		            expect(page).to have_title("#{third_biz.name}, #{third_biz.city}")
		        end
	        end

	        describe "when current_user has more than one businesses" do
	     		
	        	let!(:second_owner_2)	{ FactoryGirl.create(:ownership, 
						business: second_biz,
						user: team_member,
						email_address: team_member.email,
						created_by: founder.id) }

	     		it "should be able to delete a business" do   #provided no user activity yet
		            expect do
		              click_link('delete', href: my_business_path(founder_biz))
		            end.to change(Business, :count).by(-1)
		            expect(page).to have_title('My businesses')
		            expect(page).not_to have_selector('li', text: founder_biz.name)
		        end
	        end


		end

		describe "can view details of team-member business on the Show page" do

			before { visit my_business_path(founder_biz) }

			it { should have_selector('h1', text: "Business details") }
      		it { should have_selector('div.detail', text: founder_biz.name) }
		end

		describe "can access the Edit page of team-member businesses" do

			before { visit edit_my_business_path(founder_biz) }

			it { should have_title("Edit business") }
			it { should have_selector('input#business_name') }

			describe "and update successfully" do

				let(:new_name) { "New Name" }

				before do
					fill_in "Business name",		with: new_name
					click_button "Confirm"
		        end

              	it { should have_title("#{new_name}, #{founder_biz.city}") }
              	it { should have_selector('div.alert.alert-success', text: "'#{new_name}' updated") }
			end
		end
	end
end
