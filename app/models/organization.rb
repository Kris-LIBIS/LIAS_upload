require 'fileutils'

class Organization < ActiveRecord::Base
  #noinspection RailsParamDefResolve
  attr_accessible :contact, :name, :upload_directory

  validates :name, presence: true, uniqueness: true
  validates :upload_directory, presence: true, uniqueness: true

  has_many :users, dependent: :destroy
  before_destroy :delete_upload_dir

  def full_path
    Pathname.new(ApplicationController::UPLOAD_DIR) + self.upload_directory
  end

  private

  def delete_upload_dir
    FileUtils.rm_r full_path
  end
end
