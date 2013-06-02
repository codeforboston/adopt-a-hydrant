class ThingsController < ApplicationController
  respond_to :json

  def show
    if params[:id].blank?
      @things = Thing.find_closest(params[:lat], params[:lng], params[:limit] || 10)
      unless @things.blank?
        respond_with @things
      else
        render(json: {errors: {address: [t("errors.not_found", thing: t("defaults.thing"))]}}, status: 404)
      end
    else
      respond_with Thing.find(params[:id])
    end
  end

  def update
    @thing = Thing.find(params[:id])
    if @thing.update_attributes(thing_params)
      Event.create!(:user_id => current_user.id, :thing_id => @thing.id, :event_type_id => EventType.where(action: (params[:thing][:user_id].blank? ? 'abandoned' : 'adopted')).first.id)
      respond_with @thing
    else
      render(json: {errors: @thing.errors}, status: 500)
    end
  end

  private

  def thing_params
    params.require(:thing).permit(:name, :user_id)
  end
end
