class EventsController < ApplicationController

	def create
		@create = Event.create(:user_id => current_user.id, 
      :thing_id => params[:thing_id], :event_type_id => params[:event_type_id] )
		render :json => {:count => Event.count(:conditions => {:user_id => current_user.id, 
      :thing_id => params[:thing_id], :event_type_id => params[:event_type_id]})}, :status => :created
	end

end