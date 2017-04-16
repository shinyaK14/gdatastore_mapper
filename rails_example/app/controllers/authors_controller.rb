class AuthorsController < ApplicationController
  def index
    @authors = Author.order(created_at: :desc)
  end

  def new
    @author = Author.new
  end

  def edit
    @author = Author.find params[:id]
  end

  def update
    @author = Author.find params[:id]

    if @author.update author_params
      flash[:success] = "Updated author"
      redirect_to author_books_path(@author)
    else
      render :edit
    end
  end

  def destroy
    @author = Author.find params[:id]
    @author.delete_books
    @author.destroy
    redirect_to authors_path
  end

  def create
    @author = Author.new author_params

    if @author.save
      flash[:success] = "Added author"
      redirect_to author_books_path(@author)
    else
      render :new
    end
  end

  private

  def author_params
    params.require(:author).permit(:name)
  end

end
