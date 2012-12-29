class ReportsController < ApplicationController
  def index
    @namespace = Namespace.find(params[:namespace_id])
    @project = Project.find(params[:project_id])
    @reports = @project.reports.by_period(params[:period])
  end
end
