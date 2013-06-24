class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :find_or_create_user

  def facebook
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = auth_hash
      redirect_to new_user_registration_url
    end
  end

  def twitter
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
    else
      session["devise.twitter_data"] = auth_hash
      redirect_to new_user_registration_url
    end
  end

private
  
  def find_or_create_user
    @user = User.find_or_create_oauth_user(auth_hash, current_user)
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end