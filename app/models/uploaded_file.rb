require 'fileutils'
require 'pathname'

class UploadedFile < ApplicationRecord

  validate :file_path_valid

  belongs_to :upload

  before_destroy :delete_file

  attribute :selected

  def relative_file_path
    [self.relative_path, self.file_name].reject {|i| i.nil? or i.empty?}.join('/')
  end

  def full_path
    self.upload.full_path + relative_path
  end

  def checksum_line
    "#{self.md5sum} *#{relative_file_path}"
  end

  private

  def file_path_valid
    self.relative_path = Pathname.new(self.relative_path).cleanpath.to_s
    errors.add(:relative_path, 'Illegal relative path') if self.relative_path =~ /^\.\.($|[^.]+)/
    self.relative_path.gsub!(/^\//,'')
    self.file_name = Pathname.new(self.file_name).cleanpath.to_s
    errors.add(:file_name, 'Illegal file name') if self.file_name =~ /^\.\.\//
    self.file_name.gsub!(/^\//,'')
  end

  def delete_file
    FileUtils.rm_f self.local_path if self.local_path
  end

end
