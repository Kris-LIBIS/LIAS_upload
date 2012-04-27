#noinspection RubyResolve
class Admin::SessionController < ApplicationController
  skip_before_filter :authorize

  # GET /login
  def new
  end

  # POST /login
  def create
    user = User.find_by_name(params[:name])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      if user.admin?
        session[:admin] = true
        redirect_to admin_path
      else
        redirect_to front_end_url
      end
    else
      redirect_to login_url, :alert => 'Invalid user/password combination'
    end
  end

  # POST /logout
  def destroy
    session[:user_id] = nil
    session.delete :admin
    redirect_to login_url, :notice => "Logged out"
  end

end
