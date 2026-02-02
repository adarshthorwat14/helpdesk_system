class TicketActivityLogger
  def self.log(ticket:, user:, action:, metadata: nil)
    TicketActivity.create!(
      ticket: ticket,
      user: user,
      action: action,
      metadata: metadata
    )
  end
end
