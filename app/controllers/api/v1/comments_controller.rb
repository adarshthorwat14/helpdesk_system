module Api
  module V1
    class CommentsController < Api::BaseController

      def index
            if params[:ticket_id].present?
                comments = Comment
                            .where(ticket_id: params[:ticket_id])
                            .includes(:user)
                            .order(created_at: :asc)
            else
                comments = Comment.includes(:user).order(created_at: :asc)
            end

            render json: {
                success: true,
                data: comments.as_json(
                include: {
                    user: { only: [:id, :email] }
                }
                )
            }
            end


      def create
        comment = current_user.comments.new(comment_params)

        if comment.save
          render json: {
            success: true,
            data: comment
          }, status: :created
        else
          render json: {
            success: false,
            errors: comment.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        comment = current_user.comments.find(params[:id])
        comment.destroy

        render json: { success: true }
      end

      private

     def comment_params
        params.permit(:body, :ticket_id, :internal)
     end
    end
  end
end
