class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]

  def index
    @search = User.search(params[:q])
    @users = @search.result.page(params[:page])
  end

  # def family
  #   @other_user = Relationship.followed
  #   if current_user.mutual?(@other_user)
  #     @family = current_user.find(params[:followed_id])
  #   end
  # end

  def show
  	@user = User.find(params[:id])
    @search_microposts = @user.microposts.search(params[:q])
    @microposts = @search_microposts.result.page(params[:page])
    # @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)    
    if @user.save
      @user.update_attributes(deposit: 0.00, withdraw: 0.00, 
                              previous_month: Date.today.month, monthly_deposit: 0.00,
                              monthly_withdraw: 0.00)
      if !@user.total
        @user.update_attributes(total: 0.00)
      end
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
    # @user is defined in correct_user method
    # @user = User.find(params[:id])
  end

  def update
    # @user is defined in correct_user method
    # @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Account Deleted"
    redirect_to(root_url)
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  	def user_params
  	  params.require(:user).permit(:name, :email, :password, :password_confirmation, :total, :withdraw, :deposit)
  	end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
