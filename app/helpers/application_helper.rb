module ApplicationHelper
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
      @user = Users.search(session[:current_user_email])
      (@user.status == 2) ? true : false
    end
  end
end
