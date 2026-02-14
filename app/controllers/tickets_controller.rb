class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: [:confirm_resolution, :mark_resolved, :close]

    def index
      if current_user.user?
        redirect_to user_dashboard_path and return
      end

      base_tickets =
        if current_user.admin?
          Ticket.all
        elsif current_user.agent?
          Ticket.where(agent: current_user)
        end

      # 🔽 STATUS FILTER
      if params[:status].present?
        base_tickets = base_tickets.where(status: params[:status])
      end

      # 🔍 SEARCH BY ID OR TITLE
      if params[:query].present?
        q = params[:query].strip

        if q.match?(/\A\d+\z/)
          # If numeric → search by ID
          base_tickets = base_tickets.where(id: q.to_i)
        else
          # Otherwise → search by title
          base_tickets = base_tickets.where("title ILIKE ?", "%#{q}%")
        end
      end

      @tickets = base_tickets
                  .order(Arel.sql("COALESCE(last_commented_at, created_at) DESC"))
                  .limit(10)

      @selected_ticket =
        if params[:selected_ticket_id].present?
          @tickets.find { |t| t.id == params[:selected_ticket_id].to_i }
        else
          @tickets.first
        end

      @selected_ticket&.update_column(:last_viewed_at, Time.current)
    end





      def show
        @ticket = Ticket.find(params[:id])
      end

      def new
        @ticket = Ticket.new
      end

      def create
        @ticket = current_user.tickets.build(ticket_params)
        @ticket.status = "open"
        @ticket.last_commented_at = Time.current
        if @ticket.save
          NotificationService.notify(
            User.where(role: %w[admin agent]),
            "New ticket created: #{@ticket.title}",
            @ticket
          )
          TicketActivityLogger.log(
            ticket: @ticket,
            user: current_user,
            action: "created",
            metadata: "Ticket created"
          )
          redirect_to tickets_path, notice: "Ticket created successfully"
        else
          render :new
        end
      end

    def assign
      @ticket = Ticket.find(params[:id])

      if current_user.admin?
        @ticket.update(agent_id: params[:agent_id], status: "in_progress")

        NotificationService.notify(
          @ticket.agent,
          "You have been assigned ticket ##{@ticket.id}",
          @ticket
        )
      
        TicketActivityLogger.log(
          ticket: @ticket,
          user: current_user,
          action: "assigned",
          metadata: "Assigned to #{@ticket.agent.email}"
        )
        redirect_to tickets_path
      else
        redirect_to tickets_path, alert: "Not authorized"
      end
    end

    def update_status
      @ticket = Ticket.find(params[:id])
        @ticket.update!(
          status: params[:status],
          last_commented_at: Time.current
        )

        NotificationService.notify(
          @ticket.user,
          "Ticket ##{@ticket.id} status changed to #{@ticket.status}",
          @ticket
        )
        
        TicketActivityLogger.log(
          ticket: @ticket,
          user: current_user,
          action: "status_changed",
          metadata: "Status changed to #{@ticket.status}"
        )

        redirect_to tickets_path, notice: "Status updated successfully"
      end

  
    def mark_resolved
      @ticket = Ticket.find(params[:id])

      @ticket.update!(
        status: "waiting_confirmation"
      )

      @ticket.ticket_activities.create!(
        user: current_user,
        action: "resolved",
        metadata: "Ticket marked as resolved, waiting for user confirmation"
      )

      redirect_to @ticket, notice: "Ticket marked as resolved. Waiting for user confirmation."
    end

        def confirm_resolution
      @ticket = Ticket.find(params[:id])

      if current_user == @ticket.user
        @ticket.update!(status: "resolved")

        @ticket.ticket_activities.create!(
          user: current_user,
          action: "confirmed",
          metadata: "User confirmed issue is resolved"
        )

        redirect_to @ticket, notice: "Thanks for confirming. Agent can now close the ticket."
      else
        redirect_to @ticket, alert: "You are not authorized."
      end
    end

    def close
      @ticket = Ticket.find(params[:id])

      if @ticket.resolved? && current_user.agent?
        @ticket.update!(status: "closed")

        @ticket.ticket_activities.create!(
          user: current_user,
          action: "closed",
          metadata: "Ticket closed by agent"
        )

        redirect_to @ticket, notice: "Ticket closed successfully."
      else
        redirect_to @ticket, alert: "Ticket cannot be closed without user confirmation."
      end
    end


  private

  def ticket_params
    params.require(:ticket).permit(:title, :description, :priority, :category)
  end

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end
end
