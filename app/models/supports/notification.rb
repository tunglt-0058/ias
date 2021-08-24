class Supports::Notification < Supports::Application
  attr_reader :user_name
  attr_reader :stock_code
  attr_reader :post_display_id
  attr_reader :content
  attr_reader :read
  attr_reader :created_at

  def initialize attributes
    @user_name       = attributes[:user_name]
    @stock_code      = attributes[:stock_code]
    @post_display_id = attributes[:post_display_id]
    @content         = attributes[:content]
    @read            = attributes[:read] || false
    @created_at      = attributes[:created_at].to_s(:no_zone) if attributes[:created_at]
  end

  class << self
    def get_notifications notification_params
      current_user  = User.find_by(display_id: notification_params[:user_display_id]) || User.new
      notifications = current_user.notifications.order(created_at: :desc)
      object_paginate(notifications.paginate(page: notification_params[:current_page], per_page: Settings.notification_size))
    end

    def get_notification_number current_user_id
      current_user = User.find(current_user_id) || User.new
      current_user.notifications.where(read: false).size
    end

    def create_notification notification_params
      user  = User.find(notification_params[:recipient_id]) || User.name
      stock = Stock.find(notification_params[:stock_id]) || Stock.name
      content = "<strong>#{user.name}</strong> đã tạo bài đăng mới về cổ phiếu mã <strong>#{stock.code}</strong>"
      return notification = Notification.create(
        recipient_id: notification_params[:recipient_id], 
        stock_id: notification_params[:stock_id], 
        post_id: notification_params[:post_id],
        content: notification_params[:content] || content
      )
    end

    def mark_read current_user_id
      current_user  = User.find(current_user_id) || User.new
      notifications = current_user.notifications.where(read: false)
      notifications.each do |notification|
        notification.update(read: true)
      end
    end    

    def convert_notifications notifications
      sp_notifications = []
      notifications.each do |notification|
        sp_notifications.push(self.convert_notification(notification))
      end
      sp_notifications     
    end

    def convert_notification notification
      notification_attr = {}
      if !(notification.nil? or notification.new_record?)
        notification_attr[:user_name]       = notification.recipient.name
        notification_attr[:stock_code]      = notification.content
        notification_attr[:post_display_id] = notification.post.display_id
        notification_attr[:content]         = notification.content
        notification_attr[:read]            = notification.read
        notification_attr[:created_at]      = notification.created_at
      end
      self.new(notification_attr)
    end
  end
end
