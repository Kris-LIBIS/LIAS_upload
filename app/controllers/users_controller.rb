class UsersController < ApplicationController

  # GET /my_account
  def show
    @user = current_user

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /my_account/edit
  def edit
    @user = current_user
  end

  # PUT /my_account
  def update
    @user = current_user

    success = false
    begin
      attributes = params[:user]
      attributes.keep_if { |x| [:name, :email, :password, :password_confirmation].include? x.to_sym }
      success = @user.update_attributes(attributes)
    rescue Exception => e
      flash[:alert] = e.message
    end

    respond_to do |format|
      if success
        format.html { redirect_to front_end_path, notice: "Your account was successfully updated." }
      else
        format.html { render action: "edit" }
      end
    end
  end

end
