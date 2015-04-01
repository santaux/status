class Project < ActiveRecord::Base
  belongs_to :namespace
  has_many :reports, :dependent => :destroy

  validates :name, :host, :namespace_id, :presence => true
  validates :name, :host, :uniqueness => true

  attr_accessible :name, :host, :description

  PERIODS = %w[day week month year]

  def ping
    require 'net/http'
    require 'uri'

    begin
      delay_time = nil
      response_time = nil
      response = nil
      start_time = Time.now

      Net::HTTP.start(URI(host).host) { |http|
        http.read_timeout = 10
        delay_time = Time.now - start_time
        response = http.request_get('/')
        response_time = Time.now - start_time
      }

      return {:response_time => response_time, :delay_time => delay_time, :code => response.code.to_i, :message => response.message}
    rescue Exception => err
      Rails.logger.info "[PING FAILED] Host: #{host}. Time: #{Time.now}. Message: #{err.message}."
      return {:response_time => 0, :delay_time => 0, :code => 0, :message => err.message}
    end
  end

  def uptime(period="day")
    Rails.cache.fetch("project_#{id}_uptime_#{period}") do
      calc_uptime(reports.by_period(period).count, reports.by_period(period).failed.count)
    end
  end

  def average_delay_time(period="day")
    Rails.cache.fetch("project_#{id}_average_delay_time_#{period}") do
      reports.by_period(period).average(:delay_time)
    end
  end

  def average_response_time(period="day")
    Rails.cache.fetch("project_#{id}_average_response_time_#{period}") do
      reports.by_period(period).average(:response_time)
    end
  end

  def reports_grouped_response_time(period="day")
    Rails.cache.fetch("project_#{id}_reports_grouped_response_time_#{period}") do
      gr = reports.by_period(period).order("created_at DESC").map{ |r|
        [r.response_time, r.created_at] }.group_by { |r| r[1].send(choose_group_time(period))
      }
      gr.values.map { |v|
        average = v.map { |r| r[0] }.inject(0.0) { |sum, el| sum + el } / v.size
        [
          # get first time value to build graphs by time:
          v[0][1].to_i*1000,
          # get average response time value:
          average.to_f
        ]
      }.sort
    end
  end

  def reports_grouped_delay_time(period="day")
    Rails.cache.fetch("project_#{id}_reports_grouped_delay_time_#{period}") do
      gr = reports.by_period(period).order("created_at DESC").map{ |r|
        [r.delay_time, r.created_at] }.group_by { |r| r[1].send(choose_group_time(period))
      }
      gr.values.map { |v|
        average = v.map { |r| r[0] }.inject(0.0) { |sum, el| sum + el } / v.size
        [
          # get first time value to build graphs by time:
          v[0][1].to_i*1000,
          # get average delay time value:
          average.to_f
        ]
      }.sort
    end
  end

  def reports_grouped_uptime(period="day")
    Rails.cache.fetch("project_#{id}_reports_grouped_uptime_#{period}") do
      gr = reports.by_period(period).order("created_at DESC").map{ |r|
        [r.code, r.created_at] }.group_by { |r| r[1].send(choose_group_time(period))
      }
      gr.values.map { |v|
        all_count = v.inject(0) { |sum,i| sum += 1 }
        failed_count = v.inject(0) { |sum,i| sum += 1 if i[0] != 200; sum}
        [
          # get first time value to build graphs by time:
          v[0][1].to_i*1000,
          # get uptime value:
          calc_uptime(all_count, failed_count)
        ]
      }.sort
    end
  end

  private

  def calc_uptime(all_count,failed_count)
    ((all_count - failed_count).to_f/all_count)*100.to_f
  end

  def choose_group_time(period="day")
    case period
    when "day"
      :hour
    when "week"
      :day
    when "month"
      :day
    when "year"
      :month
    end
  end
end
