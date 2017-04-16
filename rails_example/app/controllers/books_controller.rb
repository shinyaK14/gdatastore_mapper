class BooksController < ApplicationController
  before_action :set_author, only: [:index, :new, :create]
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = @author.books
  end

  def new
    @book = Book.new
  end

  def show
  end

  def edit
    @author = @book.author
  end

  def update
    if @book.update book_params
      flash[:success] = "Updated book"
      redirect_to book_path(@book)
    else
      render :edit
    end
  end

  def destroy
    @author = @book.author
    @book.destroy
    redirect_to author_books_path(@author)
  end

  def create
    @book = @author.books.new book_params

    if @book.save
      flash[:success] = "Added book"
      redirect_to book_path(@book)
    else
      render :new
    end
  end

  private

  def set_author
    @author = Author.find params[:author_id]
  end

  def set_book
    @book = Book.find params[:id]
  end

  def book_params
    params.require(:book).permit(:title, :description)
  end

end
