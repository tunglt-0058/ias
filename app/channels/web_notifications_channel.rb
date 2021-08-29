class WebNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user.display_id
  end

  def unsubscribed
  end

  def speak data
    # Receive request from client
    Supports::Notification.mark_read(current_user.id)
  end  
end
