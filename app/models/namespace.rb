class Namespace < ActiveRecord::Base
  has_many :projects, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true

  attr_accessible :name, :description

  def uptime(period="day")
    projects.inject(0.0) { |sum,i| sum + i.uptime(period) }/projects.count
  end

  def average_delay_time(period="day")
    projects.inject(0.0) { |sum,i| sum + i.average_delay_time(period) }/projects.count
  end

  def average_response_time(period="day")
    projects.inject(0.0) { |sum,i| sum + i.average_response_time(period) }/projects.count
  end
end
