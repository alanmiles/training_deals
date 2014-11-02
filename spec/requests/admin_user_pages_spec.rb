require 'spec_helper'

describe "AdminUserPages" do
  
  subject { page }

  let!(:admin)          { FactoryGirl.create(:admin) }

  describe "when signed in as admin" do
    
    before { sign_in admin }

    describe "index" do
      
      before { visit admin_users_path }

      it { should have_title('All users') }
      it { should have_link('<- Return to main admin menu', href: root_path) }
      it { should have_selector('.table-total', text: 'Displaying 1 user') }
      it { should have_selector('#search') }
      it { should have_selector('th', text: 'Name') }
      it { should have_selector('th', text: 'Town') }
      it { should have_selector('th', text: 'Country') }
      it { should have_selector('th', text: 'Email') }
      it { should have_link("#{admin.name}", href: admin_user_path(admin)) }
      it { should have_selector('td', text: "#{admin.city}") }
      it { should have_selector('td', text: "#{admin.country}") }
      it { should have_selector('td', text: "#{admin.email}") }
      it { should have_link("Framework", href: framework_path) }
      it { should have_link("Users", href: admin_users_path) }

      describe "pagination" do

        before(:all)  { 15.times { FactoryGirl.create(:user) } }
        after(:all)   { User.delete_all }

        it { should have_selector('nav.pagination') }
      
      end

      describe "list ordered alphabetically by name" do

        let!(:user_a)  { FactoryGirl.create(:user, name: "AAA") }

        before do 
          sign_in admin
          visit admin_users_path
        end

        it { should have_selector("tr:nth-child(2)", text: user_a.name) }
        it { should have_selector("tr:last-child", text: admin.name) }
        it { should have_selector('.table-total', text: 'Displaying all 2 users') }
      end

      describe "filtering the list" do

        before { fill_in "search", with: "aa" }
      
        it { should have_selector('.table-total', text: 'Displaying 1 user') }

      end

      describe "delete links" do

        let!(:user) { FactoryGirl.create(:user) }

        before do
          sign_in admin
          visit admin_users_path
        end
        
        it { should have_link('delete', href: admin_user_path(user)) }
        it { should_not have_link('delete', href: admin_user_path(admin)) }
        
        it "should be able to delete another user" do
          expect do
            click_link('delete', href: admin_user_path(user))
          end.to change(User, :count).by(-1)
        end
        
        describe "self-deletion is forbidden" do
           before do
            click_link "Sign out"
            sign_in admin, no_capybara: true
            delete admin_user_path(admin)
          end                 
          specify { expect(response).to redirect_to(root_url) }
        end
      end
    end

    describe "Show page" do

      let!(:owner)        { FactoryGirl.create(:user) }
      let!(:owner_biz)    { FactoryGirl.create(:business, created_by: owner.id) }
      let!(:admin_biz_1)  { FactoryGirl.create(:business, created_by: admin.id) }
      let!(:admin_biz_2)  { FactoryGirl.create(:business, created_by: admin.id) }
      let!(:ownership)    { FactoryGirl.create(:ownership, business: admin_biz_1, user: owner,
                            email_address: owner.email, created_by: admin.id) }

      before { visit admin_user_path(owner) }

      it { should have_title("#{owner.name}") }
      it { should have_selector('h1', "#{owner.name}") }
      it { should have_content("#{owner.location}") }
      it { should have_content("#{owner.email}") }
      it { should have_selector('li', text: "#{owner_biz.name}, #{owner_biz.city}, #{owner_biz.country}") }
      it { should have_selector('li', text: "#{admin_biz_1.name}, #{admin_biz_1.city}, #{admin_biz_1.country}") }
      it { should_not have_selector('li', text: "#{admin_biz_2.name}, #{admin_biz_2.city}, #{admin_biz_2.country}") }
      it { should have_link("<- All users", href: admin_users_path) }
      it { should have_link("Framework", framework_path) }
    end
  end

  describe "when not signed in" do
    
    let!(:other_user)  { FactoryGirl.create(:user) }

    describe "trying to access Index page" do 

      describe "redirect to the signin page" do
        
        before { get admin_users_path }
        inaccessible_without_signin
      end

      describe "go to correct Index page after signing in" do

        before do
          visit admin_users_path
          valid_signin(admin)
        end
        
        specify do
          expect(page).to have_title('All users')
          expect(page).to have_selector('td', text: admin.name)
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

    describe "trying to access the Show page" do

      

      describe "redirect to the signin page" do
        
        before { get admin_user_path(other_user) }
        inaccessible_without_signin
      end

      describe "go to correct Show page after signing in as admin" do

        before do
          visit admin_user_path(other_user)
          valid_signin(admin)
        end
        
        specify do
          expect(page).to have_title("#{other_user.name}")
          expect(page).to have_content("#{other_user.email}")
        end

        describe "but don't go to this Show page when signing in the next time" do

          before do
            click_link "Sign out"
            sign_in admin
          end 

          specify { expect(page).not_to have_title("#{other_user.name}") }
        end
      end
    end

    describe "trying to delete a user" do

      it "should not delete a user" do
        expect do
            delete admin_user_path(other_user)
        end.not_to change(User, :count)
      end

      describe "redirect to root" do

        before { delete admin_user_path(other_user) }
        forbidden_without_signin
      end
    end
  end

  describe "when signed in but not as admin" do

    let(:user)    { FactoryGirl.create(:user) }
    let!(:alt_user)  { FactoryGirl.create(:user) }
    
    before { sign_in user, no_capybara: true }

    describe "trying to access the Index page" do

      before { get admin_users_path }

      specify do
        expect(page).to redirect_to(root_url)
        expect(flash[:error]).to eq("Permission denied.")
      end
    end

    describe "trying to access the Show page" do

      before { get admin_user_path(user) }

      specify do
        expect(page).to redirect_to(root_url)
        expect(flash[:error]).to eq("Permission denied.")
      end
    end

    describe "attempting to Destroy" do

      it "should not delete the existing user" do
        expect do
            delete admin_user_path(alt_user)
        end.not_to change(User, :count)
      end

      describe "redirects to root path" do

        before { delete admin_user_path(alt_user) }
        
        specify do
          expect(response).to redirect_to(root_path)
          expect(flash[:error]).to eq("Permission denied.")
        end
      end
    end
  end
end
