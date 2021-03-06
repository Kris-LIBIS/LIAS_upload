# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120425101446) do

  create_table "organizations", :force => true do |t|
    t.string   "name",             :null => false
    t.string   "upload_directory", :null => false
    t.string   "contact"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "uploaded_files", :force => true do |t|
    t.integer  "upload_id"
    t.string   "source_path"
    t.string   "relative_path"
    t.string   "file_name"
    t.datetime "modification_date"
    t.string   "mimetype"
    t.string   "md5sum"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "local_path"
  end

  create_table "uploads", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "date"
    t.integer  "status"
    t.text     "info"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",                               :null => false
    t.string   "email",                              :null => false
    t.string   "upload_dir",                         :null => false
    t.integer  "organization_id",                    :null => false
    t.boolean  "admin",           :default => false, :null => false
    t.string   "password_digest"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

end
