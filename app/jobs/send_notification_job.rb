class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(*params)
    WebNotificationsChannel.broadcast_to(
      params[0][:channel],
      content: params[0][:content]
    )
  end
end
