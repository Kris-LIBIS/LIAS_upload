require 'fileutils'
require 'pathname'

class User < ActiveRecord::Base
  #noinspection RailsParamDefResolve
  attr_accessible :admin, :email, :name, :organization_id, :upload_dir, :password, :password_confirmation
  belongs_to :organization
  has_many :uploads, :dependent => :destroy

  has_secure_password

  validates :name, :email, :upload_dir, presence: true
  validates_uniqueness_of :name, scope: [:organization_id]
  validates_uniqueness_of :upload_dir, scope: [:organization_id]
  validate :directory_valid

  after_destroy :ensure_an_admin_remains
  after_update :ensure_an_admin_remains
  before_destroy :delete_upload_dir

  def full_path
    self.organization.full_path + self.upload_dir
  end

  private

  def directory_valid
    self.upload_dir = Pathname.new(self.upload_dir).cleanpath.to_s
    errors.add(:upload_dir, 'Illegal upload directory') if self.upload_dir =~ /^\.($|\.($|[^.]+))/
    self.upload_dir.gsub!(/^\//,'')
  end

  def ensure_an_admin_remains
    raise "Can't delete last admin" if User.find_all_by_admin(true).size < 1
  end

  def delete_upload_dir
    FileUtils.rm_rf full_path
  end

end
