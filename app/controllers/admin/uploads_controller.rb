require 'pathname'
require 'fileutils'
require 'digest/md5'

class Admin::UploadsController < ApplicationController
  before_filter :administrator

  # GET /admin/uploads
  # GET /admin/uploads.json
  def index
    begin
      @user = User.find(params[:user_id])
      @uploads = @user.uploads.all(order: 'date DESC')
    rescue
      @uploads = Upload.all(order: 'date DESC')
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @uploads }
    end
  end

  # GET /admin/uploads/1
  # GET /admin/uploads/1.json
  def show
    @upload = Upload.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @upload }
    end
  end

  # GET /admin/uploads/1/edit
  def edit
    @upload = Upload.find(params[:id])
  end

  # PUT /admin/uploads/1
  # PUT /admin/uploads/1.json
  def update
    @upload = Upload.find(params[:id])

    respond_to do |format|
      if @upload.update_attributes(params[:upload])
        format.html { redirect_to admin_upload_path(@upload), notice: 'Upload was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/uploads/1
  # DELETE /admin/uploads/1.json
  def destroy
    upload = Upload.find(params[:id])
    upload.destroy

    respond_to do |format|
      format.html { redirect_to admin_uploads_url }
      format.json { head :no_content }
    end
  end

end
