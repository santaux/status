class Report < ActiveRecord::Base
  belongs_to :project

  validates :project_id, :code, :delay_time, :response_time, :message, :presence => true

  attr_accessible :code, :delay_time, :response_time, :message

  scope :by_period, lambda { |period| where("created_at >= '#{Time.now - 1.send(period)}'") if %w[day week month year].include?(period) }
  scope :failed, where("code <> 200")

  def failed?
    code != 200
  end

  def filtered_code
    code.zero? ? nil : code
  end
end
