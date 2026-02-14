module Api
  module V1
    class SessionsController < Api::BaseController
       skip_before_action :authenticate_request, only: [:create]
     def create
      user = User.find_by(email: login_params[:email])

      if user&.valid_password?(login_params[:password])
        token = JwtService.encode(user_id: user.id)

        render json: { success: true, message: "Login successful", token: token }
      else
        render json: 
        {success: false,
        error: { code: 401, 
        message: "Invalid email or password" }
        }, status: :unauthorized
      end
    end


      private

      def login_params
        params.require(:user).permit(:email, :password)
      end

    end
  end
end

