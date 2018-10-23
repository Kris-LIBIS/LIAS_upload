class FrontEndController < ApplicationController

  # GET /
  def index
    if params[:set_locale]
      redirect_to front_end_path(locale: params[:set_locale])
    else
      if current_user
        # noinspection RubyResolve
        if current_user.admin?
          redirect_to admin_path
        else
          redirect_to uploads_path
        end
      else
        redirect_to login_path
      end
    end
  end

  # POST /
  def locale
    index
  end

end
