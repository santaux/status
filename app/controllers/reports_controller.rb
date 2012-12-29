class ReportsController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @reports = @project.reports.by_period(params[:period])
  end
end
