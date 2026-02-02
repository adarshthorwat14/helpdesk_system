class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :agent, class_name: "User", optional: true
  has_many :comments, dependent: :destroy
  has_many :ticket_activities, dependent: :destroy
  before_create :set_initial_activity_time

  STATUSES = %w[open in_progress resolved closed]
  PRIORITIES = %w[low medium high critical]

  validates :title, :description, :status, :priority, presence: true

  def next_statuses(role)
    case status
    when "open"
      role.in?(%w[admin agent]) ? ["in_progress"] : []
    when "in_progress"
      role.in?(%w[admin agent]) ? ["resolved"] : []
    when "resolved"
      role == "user" ? ["closed"] : ["closed"]
    else
      []
    end
  end

  def unread_comments_count
  return comments.count if last_viewed_at.nil?

  comments.where("created_at > ?", last_viewed_at).count
end

# app/models/ticket.rb
      def sla_status
        return "completed" if status == "closed"

        sla_hours = case priority.downcase
                    when "low" then 72
                    when "medium" then 48
                    when "high" then 24
                    when "critical" then 4
                    else 48
                    end

        time_passed = (Time.current - created_at) / 1.hour
        percentage_left = 100 - (time_passed / sla_hours * 100)

        if percentage_left <= 0
          "breached"
        elsif percentage_left <= 20
          "critical"
        elsif percentage_left <= 50
          "warning"
        else
          "good"
        end
      end


  private

def set_initial_activity_time
  self.last_commented_at ||= Time.current
end

end
