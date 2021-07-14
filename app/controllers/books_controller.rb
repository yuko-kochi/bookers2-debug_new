class BooksController < ApplicationController
  before_action :authenticate_user!

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_new = Book.new
    @book_comment = BookComment.new
  end

  def index
    if params[:sort]
      @books = Book.all.order(params[:sort])
    else
      to  = Time.current.at_end_of_day
      from  = (to - 6.day).at_beginning_of_day
      @books = Book.includes(:favorited_users).sort {|a,b| b.favorited_users.where(created_at: from...to).size <=> a.favorited_users.where(created_at: from...to).size}
    end
    @book = Book.new
  end

  def create
    @book = current_user.books.new(book_params) 
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user == current_user
      render "edit"
    else
      redirect_to books_path
    end
  end
  
  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :rate)
  end

end
