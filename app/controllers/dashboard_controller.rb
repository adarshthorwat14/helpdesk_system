class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.user?
      redirect_to user_dashboard_path
    else
      # admin or agent
      load_admin_stats
    end
  end

  def user_dashboard
    redirect_to root_path unless current_user.user?

    @total_tickets    = current_user.tickets.count
    @open_tickets     = current_user.tickets.where(status: "open").count
    @progress_tickets = current_user.tickets.where(status: "in_progress").count
    @resolved_tickets = current_user.tickets.where(status: "resolved").count
    @closed_tickets   = current_user.tickets.where(status: "closed").count
  end

  private

  def load_admin_stats
    @total_tickets = Ticket.count
    @open_tickets  = Ticket.where(status: "open").count
    @progress_tickets = Ticket.where(status: "in_progress").count
    @resolved_tickets = Ticket.where(status: "resolved").count
    @closed_tickets   = Ticket.where(status: "closed").count
    # add agent/admin stats later
  end
end
