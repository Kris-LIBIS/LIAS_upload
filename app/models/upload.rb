require 'fileutils'
require 'pathname'

class Upload < ActiveRecord::Base
  #noinspection RailsParamDefResolve
  attr_accessible :date, :info, :name, :status, :user_id

  validates :name, :status, :user_id, presence: true
  validate :directory_valid
  validates_uniqueness_of :name, :scope => :user_id

  belongs_to :user
  has_many :uploaded_files, :dependent => :destroy

  before_destroy :delete_upload_dir

  UPLOAD_STATUS = %w( Closed Uploading Uploaded Processing Ingested )
  ALLOWED_STATUS_CHANGES_FOR_USER = {
      1 => [2],
      2 => [1]
  }

  ALLOWED_STATUS_CHANGES_FOR_ADMIN = {
      2 => [3],
      3 => [1, 4],
      4 => [0, 1, 3]
  }

  def status_options(admin = false)
    allowed_status_changes = (admin ? ALLOWED_STATUS_CHANGES_FOR_ADMIN : ALLOWED_STATUS_CHANGES_FOR_USER)
    allowed_status = Array.new(allowed_status_changes[self.status] || []) << self.status
    allowed_status.sort.collect { |i| [UPLOAD_STATUS[i], i] }
  end

  def full_path
    self.user.full_path + self.name
  end

  def date_string
    self.date.getlocal.strftime "%A %d %B %Y %H:%M:%S"
  end

  def date_short_string
    self.date.getlocal.strftime "%Y/%m/%d - %H:%M:%S"
  end

  def status_string
    UPLOAD_STATUS[self.status]
  end

  def write_attribute(attr_name, value)
    returning(super) do
      attribute_changed(attr_name, read_attribute(attr_value), value)
    end
  end

  private

  def attribute_changed(attr, old_value, new_value)
    if attr == 'status' and old_value == 2 and new_value == 3
      fp = File.open(self.full_path + '.checksums', 'w')
      self.uploaded_files.each do |file|
        fp.puts file.checksum_line
      end
      fp.close
    end
  end

  def directory_valid
    self.name = Pathname.new(self.name).cleanpath.to_s
    errors.add(:name, 'Illegal upload directory') if self.name =~ /^\.($|\.($|[^.]+))/
    self.name.gsub!(/^\//, '')
  end

  def delete_upload_dir
    FileUtils.rm_rf full_path
  end

end
