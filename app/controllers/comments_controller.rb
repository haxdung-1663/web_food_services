class CommentsController < ApplicationController
  before_action :comment_params, only: %i(create update)
  before_action :check_valid_role, only: %i(update destroy)
  before_action :load_food, only: %i(update destroy)

  def create
    @food = Food.find_by id: params[:comment][:food_id]
    @comment = @food.comments.new comment_params
    if @comment.save!
      refresh

      respond_to do |format|
        format.js
      end
    else
      flash[:danger] = t "create_comment_failed"
      redirect_to @food
    end
  end

  def update
    if @comment.update comment_params
      refresh

      respond_to do |format|
        format.js
      end
    else
      flash[:danger] = t ".Update comment failed"
      redirect_to_food
    end
  end

  def destroy
    if @comment.destroy!
      refresh

      respond_to do |format|
        format.js
      end
    else
      flash[:danger] = t "edit_comment_faild"
      redirect_to @food
    end
  end

  private

  def check_valid_role
    @comment = Comment.find_by id: params[:id]

    if @comment.nil?
      flash[:danger] = t "comment_not_found"
      redirect_to :root
    end

    return if can_edit_comment? @comment
    flash[:danger] = t "you_can_not_edit_this_comment"
    redirect_to_food
  end

  def load_food
    @food = @comment.food
  end

  def load_comment
    @comment = Comment.find_by id: params[:id]

    return if @comment
    flash[:danger] = t "comment_not_found"
    redirect_to_food
  end

  def refresh
    @comments = Comment.load_comment(@food).except_reply.select_fields
        .order_by_created_at.limit Settings.comments.limit
  end

  def redirect_to_food
    @food = load_food
    redirect_to @food
  end

  def comment_params
    params.require(:comment).permit :food_id, :content, :user_id, :parent_id
  end
end
