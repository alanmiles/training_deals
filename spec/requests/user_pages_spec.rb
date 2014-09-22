require 'spec_helper'

describe "UserPages" do
  
  subject { page }

  describe "user home page" do
  	let(:user) { FactoryGirl.create(:user) }
  	
    before(:each) do
      Business.any_instance.stub(:geocode).and_return([1,1]) 
    end
    before { visit user_path(user) }

  	it { should have_content(user.name) }
  	it { should have_title(user.name) }
    it { should_not have_link("Switch to admin interface ->", admin_menu_path) }
    it { should have_link("Instant search", href: "#") }
    it { should have_link("Saved search set-up", href: "#") }
    it { should have_link("Saved search results", href: "#") }
    
    it { should have_link("Training history", href: "#") }
    it { should have_link("Your reviews", href: "#") }
    it { should have_link("Favourites", href: "#") }
    it { should have_link("Find trainers", href: "#") }
    it { should have_link("Add a business", href: my_businesses_path) }
    it { should_not have_link("Business home page", href: my_businesses_path) }

    describe "when team-member in one or more business" do
      let!(:business_1)  { FactoryGirl.create(:business, created_by: user.id) }

      before { visit user_path(user) }

      it { should_not have_link("Add a business", href: new_my_business_path) } 
      it { should have_link("Business home page", href: my_businesses_path) } 
    end
  end

  describe "signup page" do
  	before { visit signup_path }

  	it { should have_content('Sign up') }
  	it { should have_title(full_title('Sign up')) }
    it { should have_link('<- Not now - cancel', href: root_path) }
    it { should have_selector("input#user_name") }
    it { should have_selector("input#user_email") }
    it { should have_selector("input#geocomplete") }
    it { should have_selector("input#find") }
    it { should have_selector("input#user_password") }
    it { should have_selector("input#user_password_confirmation") }
    it { should have_selector("input#latitude", visible: false) }
    it { should have_selector("input#user_longitude", visible: false) }
    it { should have_selector("input#user_city", visible: false) }
    it { should have_selector("input#user_country", visible: false) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "geocomplete",      with: "Tonbridge, United Kingdom"
        click_button 'find'
        fill_in "Name",             with: "Example User"
        fill_in "Email",            with: "user@example.com"
        fill_in "Password",         with: "foobar"
        fill_in "Confirm password", with: "foobar"
        
      end

    #  it "should create a user" do
    #    expect { click_button "Create my account" }.to change(User, :count).by(1)
    #  end

    #  describe "after saving the user" do
    #    before { click_button "Create my account" }
    #    let(:user)        { User.find_by(email: 'user@example.com') }
        
     #   it { should have_link('Sign out') }
     #   it { should have_title(user.name) }
     #   it { should have_selector('div.alert.alert-success', text: 'Welcome') } 
    end

    pending "can't test user login with JS in until Selenium (current v2.42) is compatible with Firefox 32."
    pending "can't test failing location for User create till we can test javascript"
  end

  describe "prevent a signed-in user from creating another new user record" do

    let(:signed_user) { FactoryGirl.create(:user) }
    let(:params) do
      { user: { name: "Second User", email: "second@example.com",
        password: "foobar", password_confirmation: "foobar" } }
    end
    before { sign_in signed_user, no_capybara: true }

    describe "by attempting to access the User#new page" do
      before { get new_user_path }
      specify { expect(response).to redirect_to(root_url) }
    end
 
    describe "by calling the CREATE action directly" do
      before { post users_path(params) }
      specify { expect(response).to redirect_to(root_url) }
    end

  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1', text: 'Update your profile') }
      it { should have_title('Edit user') }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
      it { should have_link('<- Cancel', href: user_path(user)) }
      it { should_not have_content("Permission denied") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)    { "New Name" }
      let(:new_email)   { "new@example.com" } 
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password 
        fill_in "Confirm password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    
      pending "no javascript testing to check location change or failed location input"
    end

    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end

      specify { expect(user.reload).not_to be_admin }
    end          
  end

  describe "when user tries to modify or view another user's pages" do

    let(:user) { FactoryGirl.create(:user) }
    let(:second_user) { FactoryGirl.create(:user) }
    
    describe "visiting the Edit page" do
      
      before do
        sign_in user
        visit edit_user_path(second_user)
      end

      it { should have_title("#{user.name}") }
      it { should_not have_selector('h1', text: 'Update your profile') }
      it { should have_content("Permission denied") }
    end

    describe "trying to update the other user's data" do

      let(:new_email)  { "changed_email@example.com"}
        
      let(:params) do
        { user: { email: new_email } }
      end
  
      before do
        sign_in user, no_capybara: true
        patch user_path(second_user), params
      end

      specify do
        expect(second_user.reload.email).not_to eq new_email
        expect(flash[:error]).to eq("Permission denied")
      end
    end

    pending "consider whether all users should be able to see user 'Show' page - OK if no contact details?"
  end
end
