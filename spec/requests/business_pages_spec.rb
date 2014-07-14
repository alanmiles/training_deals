require 'spec_helper'

describe "BusinessPages" do
  subject { page }

  	before(:each) do
 		Business.any_instance.stub(:geocode).and_return([1,1]) 
	end
  	
  	describe "dealing with the user's own businesses" do

	  	describe "signed in" do   
	  
	  		let(:user) { FactoryGirl.create(:user) }
	  		before {sign_in user }

	    	describe "index" do

	          	let!(:business_1) 	{ FactoryGirl.create(:business, created_by: user.id) }
	          	let!(:other_user_business) {FactoryGirl.create(:business, created_by: (user.id + 1).to_s) }

	          	before { visit my_businesses_path }

	            it { should have_title('My businesses') }
	            it { should have_content('My businesses') }
	            it { should have_selector('li', text: business_1.name) }
	            it { should have_selector('li', text: business_1.city) }
	            it { should have_selector('li', text: business_1.country) }
	            it { should_not have_selector('li', text: other_user_business.name) } #only own businesses
	            it { should have_link('details', href: my_business_path(business_1)) }
	            it { should have_link('delete', href: my_business_path(business_1)) }
	            it { should have_link('Add a business', href: new_my_business_path) }
		        
		        pending "No delete link when the business has a history"
		        pending "Has a 'deactivated' field if the business has been de-activated by the user"

		     	it "should be able to delete a business" do   #provided no user activity yet
		            expect do
		              click_link('delete', href: my_business_path(business_1))
		            end.to change(Business, :count).by(-1)
		            expect(page).to have_title('My businesses')
		            expect(page).not_to have_selector('li', text: business_1.name)
		        end

		        pending "should not be able to delete if user history associated"
		    end

		    describe "visit the New page" do

		        before { visit new_my_business_path }

		        it { should have_title("Add business") }
		        it { should have_content("Add my business") }
		        it { should have_link("<- My business list", href: my_businesses_path) }
		        it { should have_unchecked_field("business_hide_address") }
		        it { should have_content("Check the box to hide your address from other users") }
		        it { should_not have_content("Check the box if you no longer want users to see this business") }
		        it { should_not have_unchecked_field("business_inactive") }

		        describe "then create a new Business successfully" do
		            before do
		               	fill_in "Name",    			with: "Business X"
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

		            describe "and redirect to the Show page" do
		              	before { click_button 'Create' }

		              	it { should have_title('Business X, London') }

		              	it { should have_link('Update', href: edit_my_business_path(Business.last)) } 
		              	it { should have_selector('div.alert.alert-success', 
		              		text: "Successfully added. Please check all the details carefully.") }
		              	it { should_not have_selector('div.check-notice', 
		              		text: "Please check this address.") }  
		            end
		        end

		        describe "then create a business successfully - but without geocoding" do

		        	before do
		               	fill_in "Name",    			with: "Non-geocoded business"
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

			            	let(:latest_business) { Business.last }
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

		            describe "continue to show the New page with an error message" do

		             	before do
		                	fill_in "Name",    with: "   "
		                	click_button "Create"
		              	end
		            
		              	it { should have_title('Add business') }
		              	it { should have_content('error') }
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

		        describe "and update the Business" do

		            let(:old_name) { changed_business.name}
		            describe "succesfully" do

		              	let(:new_name)   { "New Name" }
		              	before do
		                	fill_in "Name",    with: new_name
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
		              		it { should_not have_selector("span.check-notice", "- Hidden to users") }
		              	end
		            end

		            describe "unsuccessfully" do

		            	before do
		                	fill_in "Name",    with: "  "
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
			        	it { should have_selector("span.check-notice", "- Hidden to users") }
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
			        	it { should_not have_selector("span.check-notice", "- Hidden to users") }

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
end
