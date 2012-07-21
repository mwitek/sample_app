module SigninSignupUtilites
	def valid_signin(user)
		fill_in "Email", :with => user.email
    	fill_in "Password", :with => user.password
    	click_button 'Sign In'
    	cookies[:remember_token] = user.remember_token
	end

	def valid_signup
		fill_in "Name", :with => "Jon Doe"
		fill_in "Email", :with => "email@example.com"
		fill_in "Password", :with => "foobar"
		fill_in "Confirmation", :with => "foobar"
	end
end