class UsersController < ApplicationController
  before_filter :signed_in_user, :only => [:edit, :update, :index, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  before_filter :signed_in_user_access, :only => [:new, :create]
  def new
  	@user = User.new
  end
  
  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
  end
  
  def create
  @user = User.new(params[:user])
    if @user.save
      sign_in @user
    	flash[:success] = "Welcome to the app #{@user.name}"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(:page => params[:page])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = "Great job #{@user.name}!  Your profile has been updated."
      redirect_to @user
    else
      render 'edit'
    end 
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "#{@user.name} has been destroyed."
    redirect_to users_path
  end

  def signed_in_user
    unless signed_in
      store_location
      redirect_to signin_path, :notice => "Please sign in."
    end
  end
  def signed_in_user_access
    redirect_to(user_path(current_user)) if current_user
  end
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
