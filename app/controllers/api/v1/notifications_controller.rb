module Api
  module V1
    class NotificationsController < Api::BaseController

      # GET /api/v1/notifications
      def index
        notifications = current_user.notifications
        .where(read: false)
                                    .includes(:notifiable)
                                    .order(created_at: :desc)

        render json: {
          success: true,
          data: notifications.map { |n| notification_json(n) }
        }
      end

      # PATCH /api/v1/notifications/:id
      def update
        notification = current_user.notifications.find(params[:id])

        if notification.update(read: true)
          render json: { success: true }
        else
          render json: { success: false }, status: :unprocessable_entity
        end
      end

      private

      def notification_json(notification)
        {
          id: notification.id,
          message: notification.message,
          read: notification.read,
          created_at: notification.created_at,
          notifiable_type: notification.notifiable_type,
          notifiable_id: notification.notifiable_id
        }
      end

    end
  end
end
