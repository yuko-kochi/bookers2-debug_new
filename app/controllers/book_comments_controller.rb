class BookCommentsController < ApplicationController
  
	def create
		@book = Book.find(params[:book_id])
		@comment = BookComment.new(book_comment_params)
		@comment.book_id = @book.id
		@comment.user_id = current_user.id
	  @comment.save
	 # @comment = current_user.book_comments.new(book_comment_params)
	end

  def destroy
    @book = Book.find(params[:book_id])
    @comment = @book.book_comments.find(params[:id])
    @comment.destroy
  end

  private
  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end

