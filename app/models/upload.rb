require 'fileutils'

class Upload < ActiveRecord::Base
  #noinspection RailsParamDefResolve
  attr_accessible :date, :info, :name, :status, :user_id

  validates :name, :status, :user_id, presence: true
  validates_uniqueness_of :name, :scope => :user_id

  belongs_to :user
  has_many :uploaded_files, :dependent => :destroy

  before_destroy :delete_upload_dir

  def chunck_size
    1000000
  end

  def files_per_request
    1
  end

  def full_path
    self.user.full_path + self.name
  end

  private

  def delete_upload_dir
    FileUtils.rm_rf full_path
  end

end
