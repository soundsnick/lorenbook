class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def check_auth
    session[:current_user_email] ? true : false
  end

  def check_admin
    if check_auth
      @user = Users.search(session[:current_user_email])
      @user.status == 1 || @user.status == 2
    else
      false
    end
  end

  def check_owner
    if check_auth
      @cuser = Users.search(session[:current_user_email])
      @cuser.status == 2
    else
      false
    end
  end
end
