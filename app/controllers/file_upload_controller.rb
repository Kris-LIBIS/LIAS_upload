require 'awesome_print'

class FileUploadController < ApplicationController

  before_action :authorize

  def create
    puts 'params:'
    ap params.inspect
    upload = Upload.find(params[:upload_id])
    base_dir = upload_dir(upload)

    relative_path = '' #params[:relpathinfo0]
    if request.env['HTTP_USER_AGENT'] =~ /^[^(]*[^)]*Windows[ ;)]/
      relative_path.gsub!(/\\/,'/')
    end

    target_dir = base_dir + relative_path

    file_data = params[:file_data]

    file_name = params[:file_name]
    target_path = target_dir + file_name

    if target_path.relative_path_from(base_dir).to_s =~ /^\.\./
      render json: {success: false, prevent_retry: true, error: 'ERROR : illegal relative path'} and return
    end

    FileUtils.mkdir_p(target_dir, mode: 0755)

    has_parts = !!params[:total_parts]
    partnr = params[:part_index].to_i || 0
    total_parts = (params[:total_parts] || 1).to_i
    final_chunk = !has_parts || partnr < total_parts - 1

    FileUtils.rm_f(target_path) unless partnr > 0

    chunk_size = params[:chunk_size]

    # Check expected file size
    unless chunk_size.nil? || final_chunk || chunk_size == APP_CONFIG['chunck_size']
      render json: { success: false, error: 'upload stream corrupted during transfer; please try again.'} and return
    end

    # copy the file from temp location to final target
    File.open(target_path, 'ab') { |f| f.write(file_data.read) }

    if final_chunk

      # # check MD5 checksum
      # md5sum = params[:md5sum0]
      #
      # unless check_md5(target_path, md5sum)
      #   render(text: "ERROR: md5sum check failed. Uploaded data seems to be corrupt; please try uploading the files again.") and return
      # end

      md5sum = get_md5(target_path)

      # create file object in DB
      attributes = {
          upload_id: upload.id,
          file_name: file_name,
          source_path: relative_path,
          relative_path: relative_path,
          mimetype: file_data.content_type,
          md5sum: md5sum,
          uuid: params[:uuid],
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

    respond_to do |format|
      format.json do
        render json: {success: true}
      end
    end

  end

  private

  def upload_dir(upload)
    upload.full_path
  end

  def get_md5(file)
    digest = ::Digest::MD5.new()
    File.open(file, 'rb') do |f|
      while (data = f.read(1000000))
        digest << data
      end
    end
    digest
  end

  def check_md5(file, checksum)
    digest = get_md5(file)
    puts "digest: #{digest} -- checksum: #{checksum}"
    digest == checksum
  end


end
