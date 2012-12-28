class Project < ActiveRecord::Base
  belongs_to :namespace
  has_many :reports, :dependent => :destroy

  def ping#(host)
    require 'net/http'
    require 'uri'

    begin
      # TODO: read_timeout
      # NOT SURE: message (OK, etc.)
      # TODO: EM::Aynchrony / Threads
      # TODO: Check indexes!

      delay = nil
      response_time = nil
      response = nil
      start_time = Time.now

      Net::HTTP.start(URI(host).host) { |http|
        http.read_timeout = 1
        delay = Time.now - start_time
        response = http.request_get('/')
        response_time = Time.now - start_time
      }

      return {:response_time => response_time, :delay => delay, :code => response.code, :message => response.message}
    rescue Exception => err
      Rails.logger.info "[PING FAILED] Host: #{host}. Time: #{Time.now}. Message: #{err.message}."
      return {:response_time => 0, :delay => 0, :code => 0, :message => err.message}
    end
  end
end
