class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
  	@micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def deposits(money)
  end

  def withdrawals(money)
  end

  def destroy
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :deposit, :withdraw)
    end
end
