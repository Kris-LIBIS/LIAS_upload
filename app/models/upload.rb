class Upload < ActiveRecord::Base
  attr_accessible :date, :info, :name, :status, :user_id

  has_many :uploaded_files
end
