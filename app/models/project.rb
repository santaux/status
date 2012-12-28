class Project < ActiveRecord::Base
  belongs_to :namespace
  has_many :reports, :dependent => :destroy
end
