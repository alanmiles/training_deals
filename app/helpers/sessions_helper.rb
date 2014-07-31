module SessionsHelper

	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.digest(remember_token))
		self.current_user = user
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		remember_token = User.digest(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	def current_user?(user)
		user == current_user
	end

	def sign_out
		current_user.update_attribute(:remember_token,
							User.digest(User.new_remember_token))
		cookies.delete(:remember_token)
		self.current_user = nil
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.url if request.get?
	end

	def store_mybiz(business)
		session[:mybiz] = business
	end

	def release_mybiz
		session[:mybiz] = nil
	end

	def current_business?
		session[:mybiz] != nil
	end

	def current_business
		store_mybiz(@business.id) unless current_business?
		@current_business = Business.find(session[:mybiz])
	end

	def valid_team_member?(business)
		record = business.ownerships.find_by(user_id: current_user.id)
		!record.nil?
	end
end
