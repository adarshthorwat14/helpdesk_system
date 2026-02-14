class Api::BaseController < ActionController::API
  before_action :authenticate_request

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from StandardError, with: :internal_server_error
  private

  def authenticate_request
    header = request.headers['Authorization']
      token = header.split(' ').last if header

      decoded = JwtService.decode(token)
      @current_user = User.find(decoded[:user_id]) if decoded

      render_unauthorized unless @current_user
    rescue
      render_unauthorized
  end

  def render_unauthorized
    render json: {
      success: false,
      error: {
        code: 401,
        message: "Unauthorized"
      }
    }, status: :unauthorized
  end

  def record_not_found
    render json: {
      success: false,
      error: {
        code: 404,
        message: "Record not found"
      }
    }, status: :not_found
  end

  def parameter_missing(exception)
    render json: {
      success: false,
      error: {
        code: 400,
        message: exception.message
      }
    }, status: :bad_request
  end


  def internal_server_error(exception)
      Rails.logger.error exception.message
      Rails.logger.error exception.backtrace.join("\n")

      render json: {
        success: false,
        error: {
          code: 500,
          message: "Internal server error"
        }
      }, status: :internal_server_error
  end

end
