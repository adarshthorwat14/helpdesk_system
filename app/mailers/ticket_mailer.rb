class TicketMailer < ApplicationMailer
  def ticket_assigned(agent, ticket)
    @agent = agent
    @ticket = ticket

    mail(
      to: @agent.email,
      subject: "New Ticket Assigned ##{@ticket.id}"
    )
  end
end
