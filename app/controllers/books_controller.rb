class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = Book.order(id: :desc)
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def edit; end

  def create
    uploaded_img = book_params[:img]
    uploaded_pdf = book_params[:file]
    File.open(Rails.root.join('public', 'covers', uploaded_img.original_filename), 'wb') do |file|
      file.write(uploaded_img.read)
    end
    File.open(Rails.root.join('public', 'files', uploaded_pdf.original_filename), 'wb') do |file|
      file.write(uploaded_pdf.read)
    end

    form_params = book_params
    form_params[:img] = uploaded_img.original_filename
    form_params[:file] = uploaded_pdf.original_filename
    @book = Book.new(form_params)
    @book.save
    redirect_to root_path, notice: form_params[:title] + ' было добавлено'
  end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Успешно удалено' }
      format.json { head :no_content }
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :description, :category, :author, :tags, :file, :img)
  end
end
