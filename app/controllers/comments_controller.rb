class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @ticket = Ticket.find(params[:ticket_id])
    @comment = @ticket.comments.build(comment_params)
    @comment.user = current_user

    NotificationService.notify(
    @comment.ticket.user,
    "New comment on ticket ##{@comment.ticket.id}",
    @comment.ticket
    )

    if @comment.save
      @ticket.update_column(:last_commented_at, Time.current)
      TicketActivityLogger.log(
        ticket: @ticket,
        user: current_user,
        action: "commented",
        metadata: @comment.internal? ? "Internal comment" : "Public comment"
      )
      redirect_to tickets_path(selected_ticket_id: @ticket.id),
                  notice: "Comment added successfully"
    else
      redirect_to tickets_path(selected_ticket_id: @ticket.id),
                  alert: "Comment could not be added"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :internal)
  end
end
