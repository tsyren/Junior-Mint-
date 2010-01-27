# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 2147483647) do

  create_table "accesses", :force => true do |t|
    t.integer "user_id"
    t.integer "model_id"
    t.string  "model_name", :limit => 100
  end

  create_table "answers", :force => true do |t|
    t.integer "question_id"
    t.text    "answer"
    t.integer "user_id"
  end

  create_table "bookmarks", :force => true do |t|
    t.string   "title"
    t.string   "bookmarkable_type", :limit => 15, :default => "", :null => false
    t.integer  "bookmarkable_id",                 :default => 0,  :null => false
    t.integer  "user_id",                         :default => 0,  :null => false
    t.datetime "created_at",                                      :null => false
  end

  create_table "brain_busters", :force => true do |t|
    t.string "question"
    t.string "answer"
  end

  create_table "comments", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",   :limit => 10, :default => 1, :null => false
  end

  create_table "communities", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.enum     "status",      :limit => [:private, :public], :default => :public
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "searchable"
    t.integer  "visits"
  end

  create_table "communities_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "community_id"
    t.enum     "status",       :limit => [:creator, :moderator, :reader, :member], :default => :member
    t.datetime "created_at"
  end

  add_index "communities_users", ["community_id"], :name => "community_id"

  create_table "datafiles", :force => true do |t|
    t.integer "user_id"
    t.integer "model_id"
    t.string  "model_name",   :limit => 150
    t.integer "avatar",                      :default => 0
    t.string  "filename"
    t.string  "content_type"
    t.string  "thumbnail"
    t.integer "size"
    t.integer "width"
    t.integer "height"
  end

  create_table "events", :force => true do |t|
    t.datetime "started_on",                                 :null => false
    t.datetime "finished_on",                                :null => false
    t.datetime "created_at",                                 :null => false
    t.string   "updated_at",  :limit => 45,  :default => "", :null => false
    t.integer  "user_id",                                    :null => false
    t.integer  "post_id",                                    :null => false
    t.string   "place",       :limit => 256, :default => "", :null => false
  end

  create_table "events_users", :primary_key => "Id", :force => true do |t|
    t.integer "user_id",  :limit => 4
    t.integer "event_id", :limit => 4
  end

  create_table "feeds", :force => true do |t|
    t.string   "url",                        :default => "",      :null => false
    t.text     "description",                :default => "",      :null => false
    t.integer  "community_id", :limit => 10,                      :null => false
    t.integer  "length",       :limit => 10, :default => 7,       :null => false
    t.string   "name",                       :default => "",      :null => false
    t.string   "encoding",                   :default => "utf-8"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.string  "status"
  end

  create_table "invites", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "user_id"
    t.integer  "model_id"
    t.string   "model_name", :limit => 100
    t.enum     "status",     :limit => [:forbidden, :accepted, :refuse, :waiting], :default => :waiting
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "about"
  end

  create_table "jobs", :force => true do |t|
    t.string   "worker_class"
    t.string   "worker_method"
    t.text     "args"
    t.text     "result"
    t.integer  "priority"
    t.integer  "progress"
    t.string   "state"
    t.integer  "lock_version",  :default => 0
    t.datetime "start_at"
    t.datetime "started_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "jobs", ["state"], :name => "index_jobs_on_state"
  add_index "jobs", ["start_at"], :name => "index_jobs_on_start_at"
  add_index "jobs", ["priority"], :name => "index_jobs_on_priority"

  create_table "justrequests", :force => true do |t|
    t.integer "user_id"
    t.integer "model_id"
    t.string  "model_name", :limit => 11
    t.enum    "status",     :limit => [:forbbiden, :accepted, :waiting]
    t.text    "text"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "reciever"
    t.string   "title"
    t.text     "content"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",                  :null => false
    t.string  "server_url"
    t.string  "salt",       :default => "", :null => false
  end

  create_table "open_id_authentication_settings", :force => true do |t|
    t.string "setting"
    t.binary "value"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "community_id"
    t.string   "title"
    t.text     "content"
    t.enum     "status",       :limit => [:public, :private, :protected, :external], :default => :public
    t.enum     "final",        :limit => [:post, :event],                            :default => :post
    t.integer  "commentable",  :limit => 10,                                         :default => 1,       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "searchable"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.enum     "status",          :limit => [:other, :lecture, :student]
    t.enum     "sex",             :limit => [:female, :male]
    t.date     "birthday"
    t.integer  "icq"
    t.string   "phone",           :limit => 30
    t.string   "email",           :limit => 256
    t.string   "work",            :limit => 256
    t.text     "desc_work"
    t.string   "position",        :limit => 256
    t.string   "university",      :limit => 256
    t.string   "department",      :limit => 256
    t.string   "chair",           :limit => 256
    t.integer  "group",           :limit => 10
    t.text     "about"
    t.text     "hobby"
    t.string   "relationships"
    t.string   "language"
    t.text     "firsttome"
    t.text     "books"
    t.text     "music"
    t.text     "films"
    t.text     "cuisine"
    t.string   "average",         :limit => 30
    t.text     "subject"
    t.string   "manager"
    t.string   "industry"
    t.string   "degree"
    t.text     "participates"
    t.text     "aim_year"
    t.text     "aim_five_year"
    t.text     "work_wishes"
    t.text     "publication"
    t.text     "computer_skills"
    t.string   "contact_email",   :limit => 256
    t.text     "education"
    t.string   "work_phone",      :limit => 100
    t.enum     "access",          :limit => [:custome, :private, :public],                  :default => :public
    t.enum     "column",          :limit => [:everything, :events, :friends, :communities], :default => :everything
    t.datetime "time_zone"
  end

  create_table "projects", :force => true do |t|
    t.integer  "user_id"
    t.integer  "community_id"
    t.string   "title"
    t.text     "description"
    t.enum     "status",       :limit => [:private, :public], :default => :private
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "searchable"
  end

  create_table "projects_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.enum     "status",     :limit => [:creator, :admin, :member], :default => :member
    t.datetime "created_at"
  end

  add_index "projects_users", ["project_id"], :name => "community_id"

  create_table "questions", :force => true do |t|
    t.string  "question",     :limit => 256
    t.integer "community_id"
  end

  create_table "schema_migrations", :primary_key => "version", :force => true do |t|
  end

  add_index "schema_migrations", ["version"], :name => "unique_schema_migrations", :unique => true

  create_table "stores", :force => true do |t|
    t.string   "store_file_name"
    t.string   "store_content_type"
    t.integer  "store_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.text     "description"
    t.string   "name"
    t.integer  "dcount",             :default => 0
  end

  create_table "subscribes", :force => true do |t|
    t.integer "user_id"
    t.integer "model_id"
    t.string  "model_type", :limit => 256
    t.enum    "status",     :limit => [:recieving, :refused]
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
    t.text   "searchable"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "password_reset_code",       :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.text     "searchable"
    t.string   "identity_url"
  end

end
