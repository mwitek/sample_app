class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by_email(params[:session][:email])
		if user && user.authenticate(params[:session][:password])
		flash[:success] = "Welcome to the app #{user.name}"
      	sign_in user
      	redirect_to user
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
