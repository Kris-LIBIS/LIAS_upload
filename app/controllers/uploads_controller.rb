require 'pathname'
require 'fileutils'

class UploadsController < ApplicationController
  # GET /uploads
  # GET /uploads.json
  def index
    @uploads = Upload.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @uploads }
    end
  end

  # GET /uploads/1
  # GET /uploads/1.json
  def show
    @upload = Upload.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @upload }
    end
  end

  # GET /uploads/new
  # GET /uploads/new.json
  def new
    @upload = Upload.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @upload }
    end
  end

  # GET /uploads/1/edit
  def edit
    @upload = Upload.find(params[:id])
  end

  # POST /uploads
  # POST /uploads.json
  def create
    @upload = Upload.new(params[:upload])

    respond_to do |format|
      if @upload.save
        format.html { redirect_to @upload, notice: 'Upload was successfully created.' }
        format.json { render json: @upload, status: :created, location: @upload }
      else
        format.html { render action: "new" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /uploads/1
  # PUT /uploads/1.json
  def update
    @upload = Upload.find(params[:id])

    respond_to do |format|
      if @upload.update_attributes(params[:upload])
        format.html { redirect_to @upload, notice: 'Upload was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.json
  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy
    1
    respond_to do |format|
      format.html { redirect_to uploads_url }
      format.json { head :no_content }
    end
  end

  # PUT /uploads/1/upload
  def upload
    @upload = Upload.find(params[:id])

    respond_to do |format|
      if params[:File0]
        new_file = {}
        new_file[:upload_id] = @upload.id
        new_file[:file_name] = params[:File0].original_filename
        new_file[:source_path] = params[:pathinfo0]
        new_file[:relative_path] = params[:relpathinfo0]
        new_file[:mimetype] = params[:File0].content_type
        new_file[:md5sum] = params[:md5sum0]
#        new_file[:modification_date] = params[:filemodificationdate0]
        target_path = Pathname.new '/temp/uploads'
        target_path += new_file[:relative_path]
        target_path += new_file[:file_name]
        FileUtils.mkdir_p target_path.dirname, mode: 0777
        File.open(target_path, 'wb') { |f| f.write(params[:File0].read) }
        UploadedFile.new(new_file).save
      end
      format.html
    end

  end
end
