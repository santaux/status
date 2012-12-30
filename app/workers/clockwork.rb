require 'sidekiq'
require "clockwork"

class PingsWorker
  include Sidekiq::Worker

  def perform
    threads = []
    Project.all.each do |project|
      threads << Thread.new(project) do |p|
        p.reports.create(p.ping)
      end
    end
    threads.each {|t| t.join }
  end
end

module Clockwork
  every 1.minute, "minute.job" do
    PingsWorker.perform_async
  end
end
