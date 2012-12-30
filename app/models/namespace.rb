class Namespace < ActiveRecord::Base
  has_many :projects, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true

  attr_accessible :name, :description
end
