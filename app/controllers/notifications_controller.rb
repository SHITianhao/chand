class NotificationsController < ApplicationController
  def index
  end
  
def create
  @notifications = Notifications.new(params.require(:notifications).permit(:username, :text, :touser, :msgtype,
  :created_at, :updated_at))
 
  @notifications.save

end
end
