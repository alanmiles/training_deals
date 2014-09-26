require 'spec_helper'

describe "PasswordResets" do
  
#  subject { page }

  #let!(:user) { FactoryGirl.create(:user) }
  
  #describe "Email user when requesting password reset" do
  #  before do 
  #  	visit signin_path
  #	    click_link "Forgotten password?"
	#    fill_in "Email", :with => user.email
	#    click_button "Reset Password"
#	end

#	it { should have_content("Email sent with password reset instructions.") }
#  	last_email.to.should include(user.email)
#  end

  it "emails user when requesting password reset" do
    user = FactoryGirl.create(:user)
    visit signin_path
    click_link "Forgotten password?"
    fill_in "Email", with: user.email
    click_button "Reset Password"
    page.should have_content("Email sent with password reset instructions.")
    last_email.to.should include(user.email)
  end

  it "does not email invalid user when requesting password reset" do
    visit signin_path
    click_link "Forgotten password?"
    fill_in "Email", with: "madeupuser@example.com"
    click_button "Reset Password"
    page.should have_content("Email sent with password reset instructions.")
    last_email.should be_nil
  end

  it "updates the user password when confirmation matches" do
    user = FactoryGirl.create(:user, password_reset_token: "something", password_reset_sent_at: 1.hour.ago)
    visit edit_password_reset_path(user.password_reset_token)
    fill_in "Password", with: "foobar10"
    click_button "Update Password"
    page.should have_content("Password confirmation doesn't match Password")
    fill_in "Password", with: "foobar10"
    fill_in "Password confirmation", with: "foobar10"
    click_button "Update Password"
    page.should have_content("Password has been reset")
  end

  it "reports when password token has expired" do
    user = FactoryGirl.create(:user, password_reset_token: "something", password_reset_sent_at: 5.hour.ago)
    visit edit_password_reset_path(user.password_reset_token)
    fill_in "Password", with: "foobar10"
    fill_in "Password confirmation", with: "foobar10"
    click_button "Update Password"
    page.should have_content("Password reset has expired")
  end

  it "raises record not found when password token is invalid" do
    visit edit_password_reset_path("invalid")
    page.should have_content("This link is invalid. Please send a new password reset request.")
  end

end
