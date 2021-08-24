class NotificationsController < ApplicationController
  def index
    @notifications = Supports::Notification.get_notifications(notification_params)
  end

  private
  def notification_params
    params[:user_display_id] = current_user.display_id
    params[:current_page]    = (params[:current_page] || 1).to_i
    params.permit :user_display_id, :current_page
  end
end
