class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_initialize :set_default_role, if: :new_record?

  has_many :tickets
  has_many :assigned_tickets, class_name: "Ticket", foreign_key: "agent_id"
  has_many :comments
  has_many :notifications, dependent: :destroy
  has_many :ticket_activities

  def set_default_role
    self.role ||= "user"
  end

  def admin?
    role == "admin"
  end

  def agent?
    role == "agent"
  end

  def user?
    role == "user"
  end
end
