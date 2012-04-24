require 'pathname'
require 'fileutils'
require 'digest/md5'

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
      if (file_data = params[:File0])
        base_dir = Pathname.new upload_dir(@upload)
        relative_path = params[:relpathinfo0]
        target_dir = base_dir + relative_path

        file_name = file_data.original_filename
        target_path = target_dir + file_name

        if target_path.relative_path_from(base_dir).to_s =~ /^\.\./
          return render text: 'ERROR : illegal relative path'
        end

        # create target folder
        FileUtils.mkdir_p target_path.dirname, mode: 0777

        # copy the file from temp location to final target
        File.open(target_path, 'wb') { |f| f.write(file_data.read) }

        # check MD5 checksum
        md5sum = params[:md5sum0]
        digest = ::Digest::MD5.new()
        File.open(target_path, 'rb') do |f|
          while data = f.read(1000000)
            digest << data
          end
        end
        unless digest == md5sum
          return render text: "ERROR: md5sum check failed. Uploaded data seems to be corrupt; please try uploading the files again."
        end

        # create file object in DB
        UploadedFile.new(
            upload_id: @upload.id,
            file_name: file_name,
            source_path: params[:pathinfo0],
            relative_path: relative_path,
            mimetype: file_data.content_type,
            md5sum: md5sum,
            # modification_date: params[:filemodificationdate0],
            local_path: target_path
        ).save
        return render text: 'SUCCESS'
      end
      format.html
    end
  end

  private

  def upload_dir(upload)
    dir = Pathname.new(super())
    dir = dir.join(upload.id.to_s)
    dir.to_s
  end

end
