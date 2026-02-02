class AddNotNullToNotificationsRead < ActiveRecord::Migration[7.0]
  def change
    change_column_null :notifications, :read, false, false
  end
end
