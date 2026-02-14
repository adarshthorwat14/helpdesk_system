module Api
  module V1
    class UsersController < Api::BaseController

      def update_fcm_token
        if current_user.update(fcm_token: params[:fcm_token])
          render json: { success: true }
        else
          render json: { success: false }, status: :unprocessable_entity
        end
      end

    end
  end
end
