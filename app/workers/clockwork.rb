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

class CacheWorker
  include Sidekiq::Worker

  def perform
    Project::PERIODS.each do |period|
      Project.all.each do |project|
        # Delete data from cache:
        Rails.cache.delete("project_#{project.id}_uptime_#{period}")
        Rails.cache.delete("project_#{project.id}_average_delay_time_#{period}")
        Rails.cache.delete("project_#{project.id}_average_response_time_#{period}")
        Rails.cache.delete("project_#{project.id}_reports_grouped_response_time_#{period}")
        Rails.cache.delete("project_#{project.id}_reports_grouped_delay_time_#{period}")
        Rails.cache.delete("project_#{project.id}_reports_grouped_uptime_#{period}")

        # Write new data into cache:
        project.uptime(period)
        project.average_delay_time(period)
        project.average_response_time(period)
        project.reports_grouped_response_time(period)
        project.reports_grouped_delay_time(period)
        project.reports_grouped_uptime(period)
      end

      Namespace.all.each do |namespace|
        # Delete data from cache:
        Rails.cache.delete("namespace_#{namespace.id}_uptime_#{period}")
        Rails.cache.delete("namespace_#{namespace.id}_average_delay_time_#{period}")
        Rails.cache.delete("namespace_#{namespace.id}_average_response_time_#{period}")

        # Write new data into cache:
        namespace.uptime(period)
        namespace.average_delay_time(period)
        namespace.average_response_time(period)
      end
    end
  end
end

module Clockwork
  every 1.minute, "minute.job" do
    PingsWorker.perform_async
  end

  every 10.minutes, "10minutes.job" do
    CacheWorker.perform_async
  end
end
