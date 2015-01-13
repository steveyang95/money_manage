class UsersController < ApplicationController

  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)    
    if @user.save
      # @user.send_activation_email     # same as: UserMailer.account_activation(@user).deliver
      # flash[:info] = "Please check your email to activate your account."
      log_in @user
      flash[:info] = "Signed up successfully!"
      redirect_to(root_url)
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
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  # def following
  #   @title = "Following"
  #   @user  = User.find(params[:id])
  #   @users = @user.following.paginate(page: params[:page])
  #   render 'show_follow'
  # end

  # def followers
  #   @title = "Followers"
  #   @user  = User.find(params[:id])
  #   @users = @user.followers.paginate(page: params[:page])
  #   render 'show_follow'
  # end

  private

  	def user_params
  	  params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end
end
