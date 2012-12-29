class NamespacesController < ApplicationController
  def index
    @namespace = Namespace.first
    @project = @namespace.projects.first
    @reports = @project.reports.by_period("day")
  end

  def show
    @namespace = Namespace.find(params[:id])
    @project = @namespace.projects.first
    @reports = @project.reports.by_period("day")
  end
end
