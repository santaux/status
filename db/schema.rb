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

ActiveRecord::Schema.define(:version => 20121228183241) do

  create_table "namespaces", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "projects", :force => true do |t|
    t.integer  "namespace_id", :null => false
    t.string   "name",         :null => false
    t.string   "host",         :null => false
    t.string   "description"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "reports", :force => true do |t|
    t.integer  "project_id",                                                   :null => false
    t.integer  "code",                                        :default => 0,   :null => false
    t.decimal  "delay_time",    :precision => 6, :scale => 2, :default => 0.0, :null => false
    t.decimal  "response_time", :precision => 6, :scale => 2, :default => 0.0, :null => false
    t.string   "message",                                                      :null => false
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  add_index "reports", ["created_at"], :name => "index_reports_on_created_at"
  add_index "reports", ["project_id", "code"], :name => "index_reports_on_project_id_and_code"
  add_index "reports", ["project_id"], :name => "index_reports_on_project_id"

end
