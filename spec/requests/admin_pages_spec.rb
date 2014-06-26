require 'spec_helper'

describe "AdminPages" do 
  
  	subject { page }

  	describe "signed in as Admin" do 
  
  		let(:admin) { FactoryGirl.create(:admin) }
  		before {sign_in admin }

  		describe "accessing the Framework menu" do

  			before { click_link "Framework" }

	  		it { should have_selector('h1', text: "Framework updates") }
	    	it { should have_title(full_title("Framework updates")) }
	    	it { should have_link('Currencies', href: "#") }
	    	it { should have_link('Countries', href: "#") }
	    	it { should have_link('Training delivery types', href: "#") }
	    	it { should have_link('Duration units', href: "#") }

  		end
  	end

  	describe "deny access to non-admin users" do

  		describe "when not signed in" do

  			describe "submitting a GET request to the Framework menu" do

  				before { get framework_path }
	  			specify { expect(response.body).not_to match(full_title('Framework updates')) }
	        	specify { expect(response).to redirect_to(root_url) }
	    	end
  		end

  		describe "when signed in as non-admin" do

  			let(:user) { FactoryGirl.create(:user) }
  			before { sign_in user, no_capybara: true }

  			describe "submitting a GET request to the Framework menu" do

  				before { get framework_path }
	  			specify { expect(response.body).not_to match(full_title('Framework updates')) }
	        	specify { expect(response).to redirect_to(root_url) }
	    	end
  		end
  	end
end
