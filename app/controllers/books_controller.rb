class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @pageTitle = 'Новинки'
    @title = 'Новинки'
    @books = Book.limit(8).order(id: :desc)
  end

  def show
    @book = Book.find(params[:id])
    @pageTitle = @book.title
    @book
  end

  def new
    unless check_admin
      redirect_to root_path(isError: 'error'), notice: 'Вы не являетесь администратором'
    end
    @pageTitle = 'Добавить книгу'
    @actionUrl = books_path
    @actionMethod = :post
    @book = Book.new
  end

  def edit
    if !check_admin
      redirect_to root_path, notice: 'Вы не являетесь администратором'
    else
      @pageTitle = 'Редактировать'
      @book = Book.find(params[:id])
      @actionUrl = book_path
      @actionMethod = :patch
      render 'new'
    end
  end

  def create
    if !check_admin
      redirect_to root_path, notice: 'Вы не являетесь администратором'
    else
      if book_params[:img].nil? || book_params[:file].nil?
        @book = book_params
        redirect_to new_book_path(isError: 'error'), notice: 'Добавьте обложку и файл'
      else
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
    end
  end

  def update
    if !check_admin
      redirect_to root_path, notice: 'Вы не являетесь администратором'
    else
      form_params = book_params
      unless book_params[:img].nil?
        uploaded_img = form_params[:img]
        File.open(Rails.root.join('public', 'covers', uploaded_img.original_filename), 'wb') do |file|
          file.write(uploaded_img.read)
        end
        File.delete(Rails.root.join('public', 'covers', @book[:img]))
        form_params[:img] = uploaded_img.original_filename
      end
      unless book_params[:file].nil?
        uploaded_pdf = form_params[:file]
        File.open(Rails.root.join('public', 'files', uploaded_pdf.original_filename), 'wb') do |file|
          file.write(uploaded_pdf.read)
        end
        form_params[:file] = uploaded_pdf.original_filename
      end
      if @book.update(form_params)
        redirect_to books_path, notice: 'Успешно отредактировано'
      else
        redirect_to books_path, notice: 'Произошла какая то ошибка'
      end
    end
  end

  def destroy
    unless check_admin
      redirect_to root_path, notice: 'Вы не являетесь администратором'
    end
    File.delete(Rails.root.join('public', 'covers', @book[:img]))
    File.delete(Rails.root.join('public', 'files', @book[:file]))
    @book.destroy
    @comments = Comments.get(params.permit(:id)[:id])
    @comments.each(&:destroy)
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Успешно удалено' }
      format.json { head :no_content }
    end
  end

  def search
    @title = 'Поиск по запросу: ' + params[:query]
    @pageTitle = @title
    @books = Book.search(params[:query])
    render 'index'
  end

  def categories
    @title = 'Категории'
    @pageTitle = @title
    @categories = Book.pluck(:category).uniq
  end

  def category
    @title = 'Книги в категории: ' + params[:category]
    @pageTitle = params[:category]
    @books = Book.category(params[:category])
    render 'index'
  end

  def author
    @title = 'Автор: ' + params[:author]
    @pageTitle = params[:author]
    @books = Book.author(params[:author])
    render 'index'
  end

  def read
    @book = Book.find(params[:id])
    @pageTitle = @book[:title]
    File.open(Rails.root.join('public', 'files', @book[:file]), 'rb') do |io|
      @bookPdf = PDF::Reader.new(io)
      @pagesPdf = @bookPdf.pages
      @infoPdf = @bookPdf.info
      render 'read'
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
