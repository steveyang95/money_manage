class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:destroy]

  def create
  	@micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Transaction created!"
      if current_user.previous_month != Date.today.month
      	current_user.update_attributes(deposit: deposits(@micropost.deposit),
      								   withdraw: withdrawals(@micropost.withdraw),
      								   total: totals(@micropost.deposit, @micropost.withdraw),
      								   previous_month: Date.today.month, 
      								   monthly_deposit: @micropost.deposit,
      								   monthly_withdraw: @micropost.withdraw)
      else
      	current_user.update_attributes(deposit: deposits(@micropost.deposit), 
      								 withdraw: withdrawals(@micropost.withdraw),
      								 total: totals(@micropost.deposit, @micropost.withdraw),
      								 monthly_deposit: current_user.monthly_deposit + @micropost.deposit,
      								 monthly_withdraw: current_user.monthly_withdraw + @micropost.withdraw)
      end
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def deposits(money)
  	return current_user.deposit + BigDecimal(money)
  end

  def withdrawals(money)
  	return current_user.withdraw + BigDecimal(money)
  end

  def totals(dep, wit)
  	return current_user.total + BigDecimal(dep) - BigDecimal(wit)
  end

  def destroy
  	current_user.update_attributes(deposit: current_user.deposit - BigDecimal(@micropost.deposit),
  								   withdraw: current_user.withdraw - BigDecimal(@micropost.withdraw),
  								   total: current_user.total - BigDecimal(@micropost.deposit) + BigDecimal(@micropost.withdraw),
  								   monthly_deposit: current_user.monthly_deposit - @micropost.deposit,
  								   monthly_withdraw: current_user.monthly_withdraw - @micropost.withdraw)
    @micropost.destroy
    flash[:success] = "Transaction deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :deposit, :withdraw)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
