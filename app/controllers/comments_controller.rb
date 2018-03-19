class CommentsController < ApplicationController
  def add
    if check_auth
      @user = Users.search(session[:current_user_email])
      @params = comment_params.merge(author: @user.id)
      Comments.new(@params).save
      redirect_to book_path(@params[:postid])
    else
      redirect_to book_path(comment_params[:postid])
    end
  end

  def destroy
    @comment = Comments.find(params[:id])
    @user = Users.search(session[:current_user_email])
    if @user.id == @comment.author || check_admin
      @comment.destroy
    end
    redirect_to '/books/' + params[:bookid]
  end

  private

  def comment_params
    params.permit(:postid, :comment)
  end
end