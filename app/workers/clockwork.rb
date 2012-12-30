require 'sidekiq'
require "clockwork"

class PingsWorker
  include Sidekiq::Worker

  def perform
    # Some problems occurs with sqlite3 and reports creating into threads:

    #threads = []
    #Project.all.each do |project|
    #  threads << Thread.new(project) do |p|
    #    p.reports.create(p.ping)
    #  end
    #end
    #threads.each {|t| t.join }

    Project.all.each do |project|
      project.reports.create(project.ping)
    end
  end
end

module Clockwork
  every 1.minute, "minute.job" do
    PingsWorker.perform_async
  end
end
