class Admin::UploadedFilesController < ApplicationController
  before_filter :administrator

  # GET /admin/uploaded_files
  # GET /admin/uploaded_files.json
  def index
    @uploaded_files = UploadedFile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @uploaded_files }
    end
  end

  # GET /admin/uploaded_files/1
  # GET /admin/uploaded_files/1.json
  def show
    @uploaded_file = UploadedFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @uploaded_file }
    end
  end

  # GET /admin/uploaded_files/new
  # GET /admin/uploaded_files/new.json
  def new
    @uploaded_file = UploadedFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @uploaded_file }
    end
  end

  # GET /admin/uploaded_files/1/edit
  def edit
    @uploaded_file = UploadedFile.find(params[:id])
  end

  # POST /admin/uploaded_files
  # POST /admin/uploaded_files.json
  def create
    @uploaded_file = UploadedFile.new(params[:uploaded_file])

    respond_to do |format|
      if @uploaded_file.save
        format.html { redirect_to @uploaded_file, notice: 'Uploaded file was successfully created.' }
        format.json { render json: @uploaded_file, status: :created, location: @uploaded_file }
      else
        format.html { render action: "new" }
        format.json { render json: @uploaded_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/uploaded_files/1
  # PUT /admin/uploaded_files/1.json
  def update
    @uploaded_file = UploadedFile.find(params[:id])

    respond_to do |format|
      if @uploaded_file.update_attributes(params[:uploaded_file])
        format.html { redirect_to @uploaded_file, notice: 'Uploaded file was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @uploaded_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/uploaded_files/1
  # DELETE /admin/uploaded_files/1.json
  def destroy
    @uploaded_file = UploadedFile.find(params[:id])
    @uploaded_file.destroy

    respond_to do |format|
      format.html { redirect_to  uploads_path }
      format.json { head :no_content }
    end
  end
end
