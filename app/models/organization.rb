class Organization < ActiveRecord::Base
  #noinspection RailsParamDefResolve
  attr_accessible :contact, :name, :upload_directory

  validates :name, presence: true, uniqueness: true
  validates :upload_directory, presence: true, uniqueness: true

end
