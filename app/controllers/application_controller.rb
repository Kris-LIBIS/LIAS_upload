class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  before_action :authorize
  after_action :update_session
  protect_from_forgery
  helper :tags

  protected

  def authorize
    if request.format == Mime[:html] or request.format == '*/*'
      if !session[:expire] or session[:expire] < Time.now
        redirect_to(login_path, notice: "You were logged out due to inactivity. Please log in again.", user_id: clear_session) and return
      end
      unless User.find_by_id(session[:user_id])
        redirect_to(login_path, notice: "Please log in", user_id: clear_session) and return
      end
    else
      authenticate_or_request_with_http_basic do |username, password|
        user = User.find_by_name(username)
        user && user.authenticate(password)
      end
    end
  end

  def administrator
    if request.format == Mime[:html]
      unless current_user_is_admin?
        # TODO: Flash does not show. Why?
        flash[:alert] = 'Access only allowed for administrators.'
        redirect_to(front_end_path) and return false
      end
    else
      false
    end
  end

  def update_session
    session[:expire] = Time.now + APP_CONFIG['inactivity_timeout'] * 60;
  end

  private

  def clear_session
    user_id = session[:user_id]
    session.delete :user_id
    user_id
  end

  def current_user
    return nil unless (user_id = session[:user_id])
    User.find(user_id)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def current_user_is_admin?
    user = current_user
    user.nil? ? false : user.admin?
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
