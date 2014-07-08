require 'spec_helper'

describe "BusinessPages" do
  subject { page }

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
		        pending "Has a 'hidden' field if the business has been de-activated by the user"

		     	it "should be able to delete a business" do
		            expect do
		              click_link('delete', href: my_business_path(business_1))
		            end.to change(Business, :count).by(-1)
		            expect(page).to have_title('My businesses')
		            expect(page).not_to have_selector('li', text: business_1.name)
		        end
		    end

		    describe "visit the New page" do

		        before { visit new_my_business_path }

		        it { should have_title("Add business") }
		        it { should have_content("Add my business") }
		        it { should have_link("<- My business list", href: my_businesses_path) }

		        describe "then create a new Business successfully" do
		            before do
		               	fill_in "Name",    			with: "Business X"
		               	fill_in "Country",			with: "United Kingdom"
		               	fill_in "Town/city",		with: "London"
		               	fill_in "Street address",	with: "1 Old Street"
		               	fill_in "Phone",			with: "071-456-7890"
		               	fill_in "Email",			with: "new_business@example.com"
		               	fill_in "Description",		with: "An exciting new business"
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

		        let!(:changed_business) { FactoryGirl.create(:business) }
		        before do
		           	visit edit_my_business_path(changed_business) 
		        end

	          	it { should have_title('Edit business') }
	          	it { should have_content('Edit business') }
	          	it { should have_link('<- Cancel', href: my_businesses_path) }

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
		    end
	    end
	end
end
