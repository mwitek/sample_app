module SigninSignupUtilites
	def login_user(user)
		visit signin_path
		fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button 'Sign In'
    cookies[:remember_token] = user.remember_token
	end

	def valid_signup
		visit signup_path
		fill_in "Name", :with => "Jon Doe"
		fill_in "Email", :with => "email@example.com"
		fill_in "Password", :with => "foobar"
		fill_in "Confirmation", :with => "foobar"
	end
end