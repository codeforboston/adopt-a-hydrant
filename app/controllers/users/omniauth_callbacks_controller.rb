class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :find_or_create_user

  def facebook
    sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  end

  def google_oauth2
    sign_in_and_redirect @user, :event => :authentication
    set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
  end

private
  
  def find_or_create_user
    redirect_to '/' and return if auth_hash.blank?
    @user = User.find_or_create_oauth_user(auth_hash, current_user)
  end

  def auth_hash
    logger.debug(request.env['omniauth.auth'])
    request.env['omniauth.auth']
  end
end