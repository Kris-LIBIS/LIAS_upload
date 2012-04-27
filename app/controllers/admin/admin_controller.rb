class Admin::AdminController < ApplicationController
  before_filter :administrator

  # GET /admin
  def index
  end

end
