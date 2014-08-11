include ApplicationHelper

def sign_in(user, options={})
	if options[:no_capybara]
		# Sign in when not using Capybara
		remember_token = User.new_remember_token
		cookies[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.digest(remember_token))
	else
		visit signin_path
		fill_in "Email", 	with: user.email
		fill_in "Password",		with: user.password
		click_button "Sign in"
	end
end

def valid_signin(user)
	fill_in "Email",			with: user.email 
	fill_in "Password",			with: user.password
	click_button "Sign in"
end

def valid_signup
	fill_in "Name",           	with: "Example User"
    fill_in "Email",          	with: "user@example.com"
    fill_in "Password",       	with: "foobar"
    fill_in "Confirm Password", with: "foobar"
end

Rspec::Matchers.define :have_error_message do |message|
	match do |page|
		expect(page).to have_selector('div.alert.alert-error', text: message)
	end
end

def check_admin_menu
	specify do
		expect(page).to have_link('Admin home page', href: admin_menu_path)
		expect(page).to have_link('Framework', href: framework_path)
	end
end

def non_admin_illegal_get(title)
	specify { expect(response.body).not_to match(full_title(title)) }
	specify { expect(response).to redirect_to(root_url) }
end

def not_administrator
	specify do
		expect(response).to redirect_to(root_url)
    	expect(flash[:notice]).to eq("You are not an authorized administrator.")
    end
end

def inaccessible_without_signin
	specify do
		expect(response).to redirect_to(signin_url)
		expect(flash[:notice]).to eq("Page not accessible. Please sign in or sign up.")
	end
end

def forbidden_without_signin
	specify do
		expect(response).to redirect_to(root_url)
    	expect(flash[:notice]).to eq("Action not permitted!")
    end
end


