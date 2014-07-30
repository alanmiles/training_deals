require 'spec_helper'

describe "ProductPages" do
  
  subject { page }

	before(:each) do
 		Business.any_instance.stub(:geocode).and_return([1,1]) 
	end

	let!(:founder) 			{ FactoryGirl.create(:user) }
	let!(:administrator)	{ FactoryGirl.create(:user) }
	let!(:founder_biz)		{ FactoryGirl.create(:business, created_by: founder.id)}

	describe "for business creator" do

		before { sign_in founder }

		describe "Index page" do

			describe "with no products defined" do

				before { visit my_business_products_path(founder_biz) }

				it { should have_title("Products & services") }
				it { should have_selector('h1', "Products & services")}
				it { should have_selector('h2', "for #{founder_biz.name}, #{founder_biz.city}") }
				it { should have_content("You now need to list all the training resources and programmes offered by your business.") }
				it { should have_link("<- Business details", my_business_path(founder_biz)) }
				it { should have_link("Add a product/service", new_my_business_product_path(founder_biz)) }
			end
		end

		describe "adding a new product" do

	        before { visit new_my_business_product_path(founder_biz) }

	        it { should have_title("Add product/service") }
	        it { should have_selector('h1', "Add a product or service") }
	        it { should have_selector('h2', text: "for #{founder_biz.name}, #{founder_biz.city}") }
		    it { should have_link("<- All products/services", my_business_products_path(founder_biz))}    
		
		    describe "Business menu" do  
	        	it { should have_link('Business home page', href: my_businesses_path) }
	        	it { should have_link('Schedules') }
	        	it { should have_link('User home page', href: user_path(founder)) }
	        end

	        describe "then create a new Product successfully" do
	            #before do
	            #   	fill_in "Business name",    			with: "Business X"
	            #   	fill_in "Street address",	with: "1 Old Street"
	            #   	fill_in "Town/city",		with: "London"
	            #   	fill_in "Post/zip code", 	with: "EC1V 9HL"
	            #   	fill_in "Phone",			with: "071-456-7890"
	            #   	fill_in "Email",			with: "new_business@example.com"
	            #   	fill_in "Description",		with: "An exciting new business"
	            #   	#country is default "United Kingdom"
	            #end

	            #it "should create a Business" do
	            #  	expect { click_button "Create" }.to change(Business, :count).by(1) 
	            #end

	            #it "should create a new Ownership record" do
	            #	expect { click_button "Create" }.to change(Ownership, :count).by(1) 
	            #end

	            #describe "and redirect to the Show page" do
	            #  	before { click_button 'Create' }

	            #  	it { should have_title('Business X, London') }
	            #  	it { should have_link('( details )', href: my_business_ownerships_path(Business.last))}
	            #  	it { should have_link('Update', href: edit_my_business_path(Business.last)) } 
	            #  	it { should have_selector('div.alert.alert-success', 
	            #  		text: "Successfully added. Please check all the details carefully.") }
	            #  	it { should_not have_selector('div.check-notice', 
	            #  		text: "Please check this address.") }  
	            #end
	        end
		end
	end
end
