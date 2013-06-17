class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @signup = Signup.new(params)

    if @signup.success?
      Mailer.welcome_email(@signup.user).deliver
      auto_login(@signup.user)
      redirect_to session[:return_to] || root_path, notice: 'Logged in!'
    else
      flash[:error] = @signup.errors
      redirect_to "/signup"
    end
  end

  def update
    @update = Signup.update(params)

    if @update == true
      redirect_to profile_path,
        :notice => "Successfully updated account"
    else
      redirect_to "/profile",
        notice: @update[:password].pop
    end
  end

  def show
    if current_user.present?
      @user = User.find(current_user.id)

      @customer = @user.customer
      @orders = @user.customer.orders
      @stores = @user.stores
      @pending_stores = @stores.order('name ASC').
                                where(approval_status: 'pending')

      @approved_stores = @stores.order('name ASC').
                                 where(approval_status: 'approved')

      @disapproved_stores = @stores.order('name ASC').
                                    where(approval_status: 'disapproved')
    else
      redirect_to login_path, alert: 'Please log in!'
    end
  end
end
