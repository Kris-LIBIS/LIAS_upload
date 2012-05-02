require 'fileutils'
require 'pathname'

class Upload < ActiveRecord::Base
  #noinspection RailsParamDefResolve
  attr_accessible :date, :info, :name, :status, :user_id

  validates :name, :status, :user_id, presence: true
  validates_uniqueness_of :name, :scope => :user_id
  validate :directory_valid

  belongs_to :user
  has_many :uploaded_files, :dependent => :destroy

  before_destroy :delete_upload_dir

  UPLOAD_STATUS = %w( Closed Uploading Uploaded Processing Ingested )

  def full_path
    self.user.full_path + self.name
  end

  private

  def directory_valid
    self.name = Pathname.new(self.name).cleanpath.to_s
    errors.add(:name, 'Illegal upload directory') if self.name =~ /^\.\.($|[^.]+)/
    self.name.gsub!(/^\//,'')
  end

  def delete_upload_dir
    FileUtils.rm_rf full_path
  end

end
