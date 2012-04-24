class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :tags

  private

  def upload_dir
    '/nas/vol04/upload/flandrica'
  end

end
