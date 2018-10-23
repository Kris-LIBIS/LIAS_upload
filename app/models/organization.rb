require 'fileutils'
require 'pathname'

class Organization < ApplicationRecord

  validates_presence_of :name, :contact, :upload_directory
  validates_uniqueness_of :name, :upload_directory
  validate :directory_valid

  has_many :users, dependent: :destroy
  before_destroy :delete_upload_dir

  def full_path
    Pathname.new(APP_CONFIG['upload_dir']) + self.upload_directory
  end

  private

  def directory_valid
    self.upload_directory = Pathname.new(self.upload_directory).cleanpath.to_s
    errors.add(:upload_directory, 'Illegal upload directory') if self.upload_directory =~ /^\.($|\.($|[^.]+))/
    self.upload_directory.gsub!(/^\//,'')
  end

  def delete_upload_dir
    FileUtils.rm_rf full_path
  end
end
