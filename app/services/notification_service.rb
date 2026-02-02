class NotificationService
  def self.notify(users, message, notifiable)
    Array(users).each do |user|
      Notification.create!(
        user: user,
        message: message,
        notifiable: notifiable,
        read: false        
      )
    end
  end
end
