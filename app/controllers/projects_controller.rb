class ProjectsController < ApplicationController
  def show
    @namespace = Namespace.find(params[:namespace_id])
    @project = Project.find(params[:id])
  end
end
