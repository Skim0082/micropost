class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    #@users = User.paginate(page: params[:page], per_page: '5')
    # Shows only active users
    @users = User.where(activated: true).paginate(page: params[:page], per_page: '5')
  end
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], per_page: '5')
    #redirect_to root_url unless @user.activated?
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      
      #log_in @user    # set session for the user id
      #flash[:success] = "Welcome to the Self-study App of Rails!"
      #redirect_to @user   # equivalent user_url(@user)
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handles a successful update
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    deleting_user_name = @user.name
    User.find(params[:id]).destroy
    flash[:success] = "'#{deleting_user_name}' user deleted."
    redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page], per_page: '5')
    #@user_avatars = @user.following.paginate(page: params[:page], per_page: '32')
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page], per_page: '5')
    #@user_avatars = @user.followers.paginate(page: params[:page], per_page: '32')
    render 'show_follow'
  end
    
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # Before filters

    
    # Confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # Confirms an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
