class Project < ActiveRecord::Base
  belongs_to :namespace
  has_many :reports, :dependent => :destroy

  validate :name, :host, :namespace_id, :presence => true
  validate :name, :host, :unique => true

  attr_accessible :name, :host, :description

  PERIODS = %w[day week month year]

  def ping#(host)
    require 'net/http'
    require 'uri'

    begin
      # TODO: read_timeout
      # NOT SURE: message (OK, etc.)
      # TODO: EM::Aynchrony / Threads
      # TODO: Check indexes!
      # TODO: Do something for navigation opening into new tabs!

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

      return {:response_time => response_time, :delay_time => delay_time, :code => response.code, :message => response.message}
    rescue Exception => err
      Rails.logger.info "[PING FAILED] Host: #{host}. Time: #{Time.now}. Message: #{err.message}."
      return {:response_time => 0, :delay_time => 0, :code => 0, :message => err.message}
    end
  end

  def uptime
    ((reports.count - reports.failed.count).to_f/reports.count)*100
  end

  def average_delay_time
    reports.average(:delay_time)
  end

  def average_response_time
    reports.average(:response_time)
  end

  def reports_grouped_response_time(period="day")
    reports.by_period(period).order("created_at DESC").map { |report| [report.created_at.to_i*1000,report.delay_time.to_f]}.to_s
  end

  def reports_grouped_delay_time(period="day")
    reports.by_period(period).order("created_at DESC").map { |report| [report.created_at.to_i*1000,report.delay_time.to_f]}.to_s
  end

  def reports_grouped_uptime(period="day")
    count = reports.by_period(period).count
    gr = reports.order("created_at DESC").map{ |r| [r.code, r.created_at] }.group_by { |r| r[1].hour }
    gr.values.map { |v|
      [
        v[0][1].to_i*1000,
        ((count - v.inject(0) { |sum,i| puts i.inspect; sum += 1 if i[0] != 200; sum}).to_f/count)*100.to_f
      ]
    }.sort
  end
end
