require 'spec_helper'

describe "UserPages" do
  
  subject { page }

  describe "index" do
    
    describe "when signed in as admin" do

      let!(:admin)    { FactoryGirl.create(:admin) }
      before do
        sign_in admin
        visit users_path
      end

      it { should have_title('All users') }
      it { should have_content('All users') }

      describe "pagination" do

        before(:all)  { 30.times { FactoryGirl.create(:user) } }
        after(:all)   { User.delete_all }

        it { should have_selector('div.pagination') }
      
        it "should list each user" do
          User.paginate(page: 1).each do |user|
            expect(page).to have_selector('li', text: user.name)
          end
        end
      end

      describe "list ordered alphabetically by name" do

        let!(:user_a)  { FactoryGirl.create(:user, name: "AAA") }

        before do 
          sign_in admin
          visit users_path
        end

        it { should have_selector("ul#userlist li:first-child", text: user_a.name) }
        it { should have_selector("ul#userlist li:last-child", text: admin.name) }
      end

      describe "delete links" do

        let!(:user) { FactoryGirl.create(:user) }

        before do
          sign_in admin
          visit users_path
        end
        
        it { should have_link('delete', href: user_path(user)) }
        it { should_not have_link('delete', href: user_path(admin)) }
        
        it "should be able to delete another user" do
          expect do
            click_link('delete', href: user_path(user))
          end.to change(User, :count).by(-1)
        end
        
        describe "self-deletion is forbidden" do
           before do
            click_link "Sign out"
            sign_in admin, no_capybara: true
            delete user_path(admin)
          end                 
          specify { expect(response).to redirect_to(root_url) }
        end
      end
    end

    describe "when not signed in" do

      let(:admin)   { FactoryGirl.create(:admin) }
      
      describe "redirect to the signin page" do
        
        before { get users_path }
        inaccessible_without_signin
      end

      describe "go to correct Index page after signing in" do

        before do
          visit users_path
          valid_signin(admin)
        end
        
        specify do
          expect(page).to have_title('All users')
          expect(page).to have_selector('li', text: admin.name)
        end

        describe "but don't go to this index page when signing in the next time" do

          before do
            click_link "Sign out"
            sign_in admin
          end 

          specify { expect(page).not_to have_title('All users') }
        end
      end
    end

    describe "when signed in but not as admin" do

      let(:user)    { FactoryGirl.create(:user) }
      let(:admin)    { FactoryGirl.create(:admin) }
      
      before do
        sign_in user, no_capybara: true
        get users_path
      end

      specify do
        expect(page).to redirect_to(root_url)
        expect(flash[:error]).to eq("Permission denied.")
      end

    end
  end


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
      before { valid_signup }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user)        { User.find_by(email: 'user@example.com') }
        
        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') } 
      end
    end
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
      it { should have_content('Update your profile') }
      it { should have_title('Edit user') }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
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
end
