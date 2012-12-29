class Report < ActiveRecord::Base
  belongs_to :project

  validate :project_id, :code, :delay_time, :response_time, :message, :presence => true

  attr_accessible :code, :delay_time, :response_time, :message

  scope :by_period, lambda { |period| where("created_at >= '#{Time.now - 1.send(period)}'") if %w[day week month year].include?(period) }
  scope :failed, where(:code => [500,0])
end
