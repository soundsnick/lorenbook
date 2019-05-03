class ApiController < ApplicationController
  def getBooks
    @books = if params[:id]
               Book.find(params[:id])
             else
               Book.all
             end
    render json: @books
  end

  def getCategories
    @categories = Book.pluck(:category).uniq
    render json: @categories
  end

  def getUsers
    if params[:access_token] == access_token
      @users = if params[:id]
                 Users.find(params[:id])
               else
                 Users.all
               end
      render json: @users
    else
      render body: 'Invalid access token'
    end
  end

  def putUser
    @userEmail = Users.search(params[:email])
    if !@userEmail
      @user = Users.new(params)
      @user.save
      render status: :ok
    else
      render status: :error
    end
  end

  private

  def access_token
    'Bv9isad08hjasd9hhhasiDj98hD9'
  end
end
