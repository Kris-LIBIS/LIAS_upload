require 'fileutils'

class UploadsController < ApplicationController
  # workaround for bug in JUpload which fails to return the cookie properly
  before_filter :authorize, except: :upload

  # GET /uploads
  # GET /uploads.json
  def index
    @user = current_user
    @uploads = current_user.uploads

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
    @upload = Upload.new(user_id: session[:user_id], date: Time.now, status: 1)

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
    @upload.user = current_user
    @upload.date = Time.now
    @upload.status = 1

    respond_to do |format|
      if @upload.save
        format.html { redirect_to uploads_path, notice: 'Upload was successfully created.' }
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
    upload = Upload.find(params[:id])

    respond_to do |format|
      if upload.update_attributes(params[:upload])
        format.html { redirect_to uploads_path, notice: 'Upload was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.json
  def destroy
    upload = Upload.find(params[:id])
    if upload.status == 1
      upload.destroy
    else
      flash[:alert] = "Deleting an upload with status '#{upload.status_string}' is not allowed."
    end

    respond_to do |format|
      format.html { redirect_to uploads_url }
      format.json { head :no_content }
    end
  end

  # GET /uploads/1/add_files
  def add_files
    @upload = Upload.find(params[:id])

    respond_to do |format|
      format.html # add_files.html.erb
      format.json { render json: @upload }
    end
  end

  # PUT /uploads/1/upload
  def upload
    @upload = Upload.find(params[:id])

    respond_to do |format|
      if (file_data = params[:File0])
        base_dir = upload_dir(@upload)
        relative_path = params[:relpathinfo0]
        if request.env['HTTP_USER_AGENT'] =~ /^[^(]*[^)]*Windows[ ;)]/
          relative_path.gsub!(/\\/,'/')
        end

        target_dir = base_dir + relative_path

        file_name = file_data.original_filename
        target_path = target_dir + file_name

        if target_path.relative_path_from(base_dir).to_s =~ /^\.\./
          render(text: 'ERROR : illegal relative path') and return
        end

        # create target folder
        FileUtils.mkdir_p target_dir, mode: 0777

        partnr = params[:jupart].to_i || 0
        final_chunk = !(params[:jufinal] == "0")

        FileUtils.rm_f(target_path) unless partnr > 1

        file_data.tempfile.seek 0, IO::SEEK_END
        chunk_size = file_data.tempfile.pos
        file_data.tempfile.rewind

        # Check expected file size
        unless final_chunk || chunk_size == APP_CONFIG['chunck_size']
          render(text: "ERROR: upload stream corrupted during transfer; please try again.") and return
        end

        # copy the file from temp location to final target
        File.open(target_path, 'ab') { |f| f.write(file_data.read) }

        if final_chunk

          # check MD5 checksum
          md5sum = params[:md5sum0]

          unless check_md5(target_path, md5sum)
            render(text: "ERROR: md5sum check failed. Uploaded data seems to be corrupt; please try uploading the files again.") and return
          end

          # create file object in DB
          attributes = {
              upload_id: @upload.id,
              file_name: file_name,
              source_path: params[:pathinfo0],
              relative_path: relative_path,
              mimetype: file_data.content_type,
              md5sum: md5sum,
              # modification_date: params[:filemodificationdate0],
              local_path: target_path.to_s,
              updated_at: Time.now
          }

          begin
            uploaded_file = UploadedFile.find_by_local_path(target_path.to_s)
            uploaded_file.update_attributes(attributes)
          rescue
            UploadedFile.new(attributes).save
          end

        end
        render(text: 'SUCCESS') and return
      end
      format.html
    end
  end

  private

  def upload_dir(upload)
    upload.full_path
  end

  def check_md5(file, checksum)
    digest = ::Digest::MD5.new()
    File.open(file, 'rb') do |f|
      while (data = f.read(1000000))
        digest << data
      end
    end
    puts "digest: #{digest} -- checksum: #{checksum}"
    digest == checksum
  end

end
