class CommentsController < ApplicationController
  def create
    comment = Comment.new(params[:comment].permit(:commentable_id, :commentable_type, :content))
    comment.user = current_user
    comment.save!
    
    if comment.commentable_type == 'User'
      redirect_to user_url(comment.commentable)
    else
      redirect_to goal_url(comment.commentable)
    end
  end
end
