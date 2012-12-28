class Report < ActiveRecord::Base
  belongs_to :project

  validate :project_id, :code, :delay, :response_time, :message, :presence => true

  attr_accessible :code, :delay, :response_time, :message
end
