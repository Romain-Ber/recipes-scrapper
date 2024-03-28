class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    @comment.post = @post

    if @comment.save
      redirect_to @post, notice: "Comment created successfully"
    else
      redirect_to @post, notice: "Comment cannot be empty"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
