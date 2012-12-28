class Namespace < ActiveRecord::Base
  has_many :projects, :dependent => :destroy

  validate :name, :presence => true

  attr_accessible :name, :description
end
