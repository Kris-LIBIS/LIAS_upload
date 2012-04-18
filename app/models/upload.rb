class Upload < ActiveRecord::Base
  attr_accessible :date, :info, :name, :status, :user_id
end
