class MyBooksController < ApplicationController
 before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:destroy]
    
   def index
     @my_books = MyBook.all
   end

  respond_to :html, :json
  def index
    @user = current_user
    @books = MyBook.all.order(:created_at)
    @read_books = ReadBook.all.order(:created_at)
  end

  def update
    @my_books = MyBook.find(params[:id])
    @my_books.update(my_books_params)
    respond_with @my_books
  end

  def destroy
    MyBook.destroy(params[:id])
    render json: {status: 'success', message: 'Book was successfully removed'}
  end

  def create_from_book_history
      book_history = BookHistory.find(params[:book_history_id])
      MyBook.create(
          title: book_history.title,
          author: book_history.author,
          description: book_history.description,
          image_url: book_history.image_url,
          isbn: book_history.isbn
      )
      redirect_to search_path
  end

  private
  def my_books_params
    params.require(:my_book).permit(:status)
  end
end

