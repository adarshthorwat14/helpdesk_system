class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

     def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    @notification.update!(read: true)

    # Update bell count
    @notification.broadcast_replace_to(
      "notifications_#{current_user.id}",
      target: "notification_count",
      html: "(#{current_user.notifications.where(read: false).count})"
    )

    respond_to do |format|
      format.turbo_stream   # inline update
      format.html { head :no_content } # fallback
    end
  end
end
