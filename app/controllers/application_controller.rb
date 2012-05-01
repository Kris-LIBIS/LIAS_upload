class ApplicationController < ActionController::Base
  before_filter :set_i18n_locale_from_params
  before_filter :authorize
  after_filter :update_session
  protect_from_forgery
  helper :tags

  UPLOAD_DIR = '/nas/vol04/upload/flandrica'
  INACTIVITY_TIMEOUT = 30; # in minutes

  protected

  def authorize
    if request.format == Mime::HTML or request.format == '*/*'
      if !session[:expire] or session[:expire] < Time.now
        redirect_to(login_path, notice: "You were logged out due to inactivity. Please log in again.", user_id: session[:user_id]) and return
      end
      unless User.find_by_id(session[:user_id])
        redirect_to(login_path, notice: "Please log in", user_id: session[:user_id]) and return
      end
    else
      authenticate_or_request_with_http_basic do |username, password|
        user = User.find_by_name(username)
        user && user.authenticate(password)
      end
    end
  end

  def administrator
    if request.format == Mime::HTML
      unless (user = User.find_by_id(session[:user_id])) && user.admin?
        redirect_to(root_path, altert: 'Access only allowed for administrators') and return
      end
    else
      false
    end
  end

  def update_session
    session[:expire] = Time.now + INACTIVITY_TIMEOUT * 60;
  end

  private

  def current_user
    return nil unless (user_id = session[:user_id])
    User.find(user_id)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def current_organization
    return nil unless (user = current_user)
    user.organization
  end

  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
        session[:locale] = params[:locale]
      else
        flash.now[:alert] =
            "#{params[:locale]} translation not available"
        logger.error flash.now[:alert]
      end
    end
  end

  def default_url_options
    {locale: I18n.locale}
  end

end
