class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by_email(params[:email])
		if user && user.authenticate(params[:password])
			flash[:success] = "Welcome to the app #{user.name}"
      		sign_in user
      		redirect_back_or user
		elsif user && !user.authenticate(params[:password])
			flash.now[:error] = 'Email found but password is invalid'
			render 'new'	
		else
			flash.now[:error] = 'Invalid email and password combination'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end

end
