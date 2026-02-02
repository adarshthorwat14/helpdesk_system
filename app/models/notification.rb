class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  after_create_commit :broadcast_notification

  private

  def broadcast_notification
    broadcast_prepend_to(
      "notifications_#{user.id}",
      target: "notification_list"
    )

    broadcast_replace_to(
      "notifications_#{user.id}",
      target: "notification_count",
      html: "(#{user.notifications.where(read: false).count})"
    )
  end
end
