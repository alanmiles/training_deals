require 'spec_helper'

describe "AdminBusinessPages" do
  
  subject { page }

  let!(:admin)        { FactoryGirl.create(:admin) }
  let!(:owner) 			  { FactoryGirl.create(:user) }
  let!(:owner_biz)		{ FactoryGirl.create(:business, created_by: owner.id) }


  describe "when signed in as admin" do
    
    before { sign_in admin }

    describe "index" do
      
      before { visit admin_businesses_path }

      it { should have_title('Current vendors') }
      it { should have_link('<- Return to main admin menu', href: root_path) }
      it { should have_selector('.table-total', text: 'Total vendors: 1') }
      it { should have_selector('#search') }
      it { should have_selector('th', text: 'Name') }
      it { should have_selector('th', text: 'Town') }
      it { should have_selector('th', text: 'Country') }
      it { should have_link("#{owner_biz.name}", href: admin_business_path(owner_biz)) }
      it { should have_selector('td', text: "#{owner_biz.city}") }
      it { should have_selector('td', text: "#{owner_biz.country}") }
      it { should have_link("Framework", href: framework_path) }
      it { should have_link("Users", href: admin_users_path) }

      #describe "pagination" do

      #  before(:all) do
      #  	@owner_user = FactoryGirl.create(:user)
      #    	15.times { FactoryGirl.create(:business, created_by: @owner_user.id) }
      #  end

      #  after(:all)   { Business.delete_all }

      #  it { should have_selector('div.pagination') }
      
      #end

      pending "pagination to be tested"

      describe "list ordered alphabetically by name (case ignored)" do

        let!(:biz_a)  { FactoryGirl.create(:business, name: "aaa", created_by: admin.id) }

        before do 
          sign_in admin
          visit admin_businesses_path
        end

        it { should have_selector("tr:nth-child(2)", text: biz_a.name) }
        it { should have_selector("tr:last-child", text: owner_biz.name) }
        it { should have_selector('.table-total', text: 'Total vendors: 2') }
      end

      describe "filtering the list" do

        before { fill_in "search", with: "aa" }
      
        it { should have_selector('.table-total', text: 'Total vendors: 1') }

      end

      describe "delete links" do

        let!(:owner_biz_2) { FactoryGirl.create(:business, created_by: owner.id) }

        before do
          sign_in admin
          visit admin_businesses_path
        end
        
        it { should have_link('delete', href: admin_business_path(owner_biz_2)) }
        
        it "should be able to delete a business" do
          expect do
            click_link('delete', href: admin_business_path(owner_biz_2))
          end.to change(Business, :count).by(-1)
        end
        
        pending "should not be able to delete businesses currently active"
      end
    end

    describe "Show page" do

      before { visit admin_business_path(owner_biz) }

      it { should have_title("#{owner_biz.name}, #{owner_biz.city}") }
      it { should have_selector('h1', "#{owner_biz.name}") }
      it { should have_content("#{owner_biz.street_address}") }
      it { should have_content("#{owner_biz.email}") }
      it { should have_link("<- All businesses", href: admin_businesses_path) }
      it { should have_link("Framework", framework_path) }

      pending "page not fully tested - current past programmes, sales, reviews, but not critical in Admin module"
    end
  end

  describe "when not signed in" do
    
    describe "trying to access Index page" do 

      describe "redirect to the signin page" do
        
        before { get admin_businesses_path }
        inaccessible_without_signin
      end

      describe "go to correct Index page after signing in" do

        before do
          visit admin_businesses_path
          valid_signin(admin)
        end
        
        specify do
          expect(page).to have_title('Current vendors')
          expect(page).to have_selector('td', text: owner_biz.name)
        end

        describe "but don't go to this index page when signing in the next time" do

          before do
            click_link "Sign out"
            sign_in admin
          end 

          specify { expect(page).not_to have_title('Current vendors') }
        end
      end
    end

    describe "trying to access the Show page" do

      describe "redirect to the signin page" do
        
        before { get admin_business_path(owner_biz) }
        inaccessible_without_signin
      end

      describe "go to correct Show page after signing in as admin" do

        before do
          visit admin_business_path(owner_biz)
          valid_signin(admin)
        end
        
        specify do
          expect(page).to have_title("#{owner_biz.name}, #{owner_biz.city}")
          expect(page).to have_content("#{owner_biz.email}")
        end

        describe "but don't go to this Show page when signing in the next time" do

          before do
            click_link "Sign out"
            sign_in admin
          end 

          specify { expect(page).not_to have_title("#{owner_biz.name}, #{owner_biz.city}") }
        end
      end
    end
  end

  describe "when signed in but not as admin" do

    let!(:user)    { FactoryGirl.create(:user) }
    
    before { sign_in user, no_capybara: true }

    describe "trying to access the Index page" do

      before { get admin_businesses_path }

      specify do
        expect(page).to redirect_to(root_url)
        expect(flash[:error]).to eq("Permission denied.")
      end
    end

    describe "trying to access the Show page" do

      before { get admin_business_path(owner_biz) }

      specify do
        expect(page).to redirect_to(root_url)
        expect(flash[:error]).to eq("Permission denied.")
      end
    end
  end
end
