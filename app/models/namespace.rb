class Namespace < ActiveRecord::Base
  has_many :projects, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true

  attr_accessible :name, :description

  def uptime(period="day")
    Rails.cache.fetch("namespace_#{id}_uptime_#{period}") do
      projects.inject(0.0) { |sum,i| sum + i.uptime(period) }/projects.count
    end
  end

  def average_delay_time(period="day")
    Rails.cache.fetch("namespace_#{id}_average_delay_time_#{period}") do
      projects.inject(0.0) { |sum,i| sum + i.average_delay_time(period).to_f }/projects.count
    end
  end

  def average_response_time(period="day")
    Rails.cache.fetch("namespace_#{id}_average_response_time_#{period}") do
      projects.inject(0.0) { |sum,i| sum + i.average_response_time(period).to_f }/projects.count
    end
  end
end
