# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProjectsController do
  let(:namespace) { FactoryGirl.create(:namespace) }
  let(:project) { FactoryGirl.create(:project, :namespace => namespace) }
  let(:report) { FactoryGirl.create(:report, :project => project) }

  before(:each) do
    namespace
    project
    report
  end

  context "#show" do
    it "should be success" do
      get :show, :id => project , :namespace_id => namespace
      response.should be_success
    end

    it "should render namespaces/index template" do
      get :show, :id => project , :namespace_id => namespace
      response.should render_template("projects/show")
    end

    it "should set correct variables" do
      get :show, :id => project , :namespace_id => namespace
      assigns[:namespace].should == namespace
      assigns[:project].should == project
      assigns[:reports].should include(report)
    end
  end
end
