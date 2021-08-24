class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :get_notification_number

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Exception, with: :render_500

  def render_404
    redirect_to not_found_index_path
  end

  def render_500
    render template: 'public/500', status: 500, layout: 'application', content_type: 'text/html'
  end

  def get_notification_number
    if user_signed_in?
      @notification_number = Supports::Notification.get_notification_number(current_user.id)
    else
      @notification_number = 0
    end
  end
end
