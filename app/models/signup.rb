class Signup
  attr_reader :customer, :user, :message

  def initialize(params)
    @customer = find_or_create_customer(params[:user][:customer])
    @user = User.create(password: params[:user][:password],
            password_confirmation: params[:user][:password_confirmation],
                     display_name: params[:user][:display_name],
                      customer_id: @customer.id)
  end

  def errors
    errors_array(user.errors.messages, customer.errors.messages)
  end

  def success?
    if customer.id && user.id
      true
    else
      false
    end
  end

  def self.update(params)
    @user = User.find(params[:id])
    @customer = Customer.find(@user.customer_id)
    if params[:display_name] != @user.display_name
      @user.update_attributes(display_name: params[:display_name])
      return true
    end
    if params[:full_name] != @customer.full_name || params[:email] != @customer.email
      @customer.update_attributes(email: params[:email])
      @customer.update_attributes(full_name: params[:full_name])
      return true
    end
    unless params[:password].blank? && params[:password_confirmation].blank?
      @user.update_attributes(password: params[:password],
                 password_confirmation: params[:password_confirmation])
      if @user.errors.messages != {}
        return @user.errors.messages
      else
        return true
      end
    end
  end

private
  def find_or_create_customer(params)
    if Customer.find_by_email(params[:email])
      Customer.find_by_email(params[:email])
    else
      Customer.create(params)
    end
  end

  def errors_array(user_errors, customer_errors)
    if missing_fields?(user_errors, customer_errors)
      ["Please fill in all required fields"]
    elsif user_errors[:customer_id] && user_errors[:customer_id].any? {|e| e == "has already been taken" }
      ["Account already exists with that email"]
    else
      formatted_errors(user_errors, customer_errors)
    end
  end

  def missing_fields?(user_errors, customer_errors)
    user_errors[:password] == "can't be blank" || customer_errors.values.flatten.any? {|f| f == "can't be blank" }
  end

  def formatted_errors(user_errors, customer_errors)
    formatted_user_errors(user_errors) + formatted_customer_errors(customer_errors)
  end

  def formatted_user_errors(user_errors)
    total = []
    if user_errors[:password]
      total << ["Password must match confirmation"]
    elsif user_errors[:display_name]
      total << ["Display name must be between 2 and 32 characters"]
    end
    total.flatten
  end

  def formatted_customer_errors(customer_errors)
    customer_errors[:email] ? ["Please enter a vaild email address"] : []
  end
end
