class Namespace < ActiveRecord::Base
  has_many :projects, :dependent => :destroy
end
