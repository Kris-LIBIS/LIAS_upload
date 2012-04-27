require 'fileutils'

class UploadedFile < ActiveRecord::Base
  #noinspection RailsParamDefResolve
  attr_accessible :file_name, :md5sum, :mimetype, :modification_date, :relative_path, :source_path, :upload_id, :local_path

  belongs_to :upload

  before_destroy :delete_file

  def relative_file_path
    [self.relative_path, self.file_name].reject {|i| i.nil? or i.empty?}.join('/')
  end

  def full_path
    self.upload.full_path + relative_path
  end

  private

  def delete_file
    FileUtils.rm_f self.local_path
  end

end
