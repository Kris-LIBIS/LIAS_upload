class UploadedFilesController < ApplicationController

  # GET /uploads/1/uploaded_files
  # GET /uploads/1/uploaded_files.json
  def index
    @upload = Upload.find(params[:upload_id])
    @uploaded_files = @upload.uploaded_files

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @uploaded_files }
    end
  end

  # GET /uploads/1/uploaded_files/1
  # GET /uploads/1/uploaded_files/1.json
  def show
    @uploaded_file = UploadedFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @uploaded_file }
    end
  end

  # GET /uploads/1/uploaded_files/1/edit
  def edit
    @uploaded_file = UploadedFile.find(params[:id])
  end

  # PUT /uploads/1/uploaded_files/1
  # PUT /uploads/1/uploaded_files/1.json
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

  # DELETE /uploads/1/uploaded_files/1
  # DELETE /uploads/1/uploaded_files/1.json
  def destroy
    @uploaded_file = UploadedFile.find(params[:id])
    upload = @uploaded_file.upload
    @uploaded_file.destroy

    respond_to do |format|
      format.html { redirect_to  upload_path(upload) }
      format.json { head :no_content }
    end
  end
end
