class IosPushNotificationJob < BaseJob
  
  def self.perform(user_id, message, sound, badge)
 	u = User.find_by_id(user_id)
 	return if u.blank? or u.ios_device_token.blank?

 	app = APN::App.find_by_name("adopt-a-hydrant")
 	return if app.blank?

 	device = APN::Device.find(:first, :conditions => {:token => u.ios_device_token, :app_id => app.id})
 	device = APN::Device.create(:token => u.ios_device_token, :app_id => app.id) if device.blank?

 	notification = APN::Notification.new
 	notification.device = device
 	notification.badge = badge # Badges? We don't need no steenkin badges.
 	notification.sound = false
 	notification.alert = message
 	notification.save!
  end

end