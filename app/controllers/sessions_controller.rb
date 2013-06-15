class SessionsController < Devise::SessionsController
  skip_before_filter  :verify_authenticity_token

  def new
    redirect_to(root_path)
  end

  def create
    resource = warden.authenticate(:scope => resource_name)
    if resource
      sign_in(resource_name, resource)
      render(json: {:user => resource, :thing => resource.things.first, :auth_token => resource.authentication_token})
    else
      render(json: {errors: {password: [t("errors.password")]}}, status: 401)
    end
  end

  def destroy
    signed_in = signed_in?(resource_name)
    sign_out(resource_name) if signed_in
    render(json: {success: signed_in})
  end
end
