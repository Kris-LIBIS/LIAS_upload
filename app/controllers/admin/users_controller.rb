class Admin::UsersController < ApplicationController
  before_action :administrator

  # GET /admin/users
  # GET /admin/users.json
  def index
    begin
      @organization = Organization.find(params[:organization_id])
      @users = @organization.users
    rescue
      @users = User.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /admin/users/1
  # GET /admin/users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /admin/users/new
  # GET /admin/users/new.json
  def new
    @user = User.new(:organization_id => params[:organization_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /admin/users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /admin/users
  # POST /admin/users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_users_path(:organization_id => @user.organization.id), notice: "User #{@user.name} was successfully created." }
        format.json { render json: @user, status: :created, location: user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/users/1
  # PUT /admin/users/1.json
  def update
    @user = User.find(params[:id])

    success = false
    begin
      success = @user.update_attributes(user_params)
    rescue Exception => e
      flash[:alert] = e.message
    end

    respond_to do |format|
      if success
        format.html { redirect_to admin_users_path, notice: "User #{@user.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.json
  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      flash[:alert] = "You are not allowed to delete yourself."
      redirect_to :back
      return
    end
    organization = @user.organization
    begin
      @user.destroy
      flash[:notice] = "User #{@user.name} deleted"
    rescue Exception => e
      flash[:alert] = e.message
    end

    respond_to do |format|
      format.html { redirect_to admin_users_url(organization_id: organization.id) }
      format.json { head :no_content }
    end
  end

  private

  def user_params
    params.require(:user).permit(:admin, :email, :name, :organization_id, :upload_dir, :password, :password_confirmation)
  end
end
