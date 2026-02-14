module Api
  module V1
    class TicketsController < Api::BaseController

      def index
        tickets = @current_user.tickets
        render json: tickets
      end

      def create
        ticket = @current_user.tickets.build(ticket_params)
        if ticket.save
            
          render json: ticket, status: :created
        else
          render json: { 
          status: false,  
          error: {
            code: 402,
            message: ticket.errors.full_messages.join(', ')
          }
        }, status: :unprocessable_entity
        end
      end

      private

      def ticket_params
        params.require(:ticket).permit(:title, :priority, :category, :description,:status)
      end

    end
  end
end
