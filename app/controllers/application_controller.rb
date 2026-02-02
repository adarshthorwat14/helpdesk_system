class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_unread_notifications
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
    before_action :authenticate_user!
  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_sign_in_path_for(resource)
    if resource.user?
      user_dashboard_path
    else
      tickets_path
    end
  end
   private

  def set_unread_notifications
  return unless user_signed_in?

  @unread_notification_count =
    current_user.notifications.where(read: false).count
end

end
