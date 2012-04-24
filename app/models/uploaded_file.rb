class UploadedFile < ActiveRecord::Base
  attr_accessible :file_name, :md5sum, :mimetype, :modification_date, :relative_path, :source_path, :upload_id, :local_path

  belongs_to :upload
end
