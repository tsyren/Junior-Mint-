class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :communities
  
  indexes_columns  :title, :description
  cattr_reader :per_page
  @@per_page = 50


  validates_presence_of :title,:description, :message => "Поле нужно заполнить"
  validates_uniqueness_of :title,  :message => "такой проект уже существует"  
  validates_length_of :title, :maximum => 100
  validates_length_of :description, :maximum => 10000

  acts_as_taggable
	
	
end
