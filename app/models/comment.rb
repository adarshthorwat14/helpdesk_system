class Comment < ApplicationRecord
  belongs_to :ticket
  belongs_to :user
  before_create :set_commented_at
  after_create :update_ticket_last_commented_at

  validates :body, presence: true



  private

  def set_commented_at
    self.commented_at = Time.current
  end

  def update_ticket_last_commented_at
    ticket.update_column(:last_commented_at, commented_at)
  end

end
