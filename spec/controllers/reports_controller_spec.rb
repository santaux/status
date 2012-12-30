# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ReportsController do
  let(:namespace) { FactoryGirl.create(:namespace) }
  let(:project) { FactoryGirl.create(:project, :namespace => namespace) }
  let(:report) { FactoryGirl.create(:report, :project => project) }

  before(:each) do
    namespace
    project
    report
  end

  context "#index" do
    it "should be success" do
      get :index, :project_id => project , :namespace_id => namespace
      response.should be_success
    end

    it "should render namespaces/index template" do
      get :index, :project_id => project , :namespace_id => namespace
      response.should render_template("reports/index")
    end

    it "should set correct variables" do
      get :index, :project_id => project , :namespace_id => namespace
      assigns[:namespace].should == namespace
      assigns[:project].should == project
      assigns[:reports].should include(report)
    end

    context "filtered by periods" do
      before(:each) do
        week_rep = FactoryGirl.create(:report, :project => project)
        week_rep.update_attribute(:created_at, Time.now - 1.day)
        month_rep = FactoryGirl.create(:report, :project => project)
        month_rep.update_attribute(:created_at, Time.now - 1.week)
      end

      it "should get 1 report for day" do
        get :index, :project_id => project , :namespace_id => namespace, :period => "day"
        assigns[:reports].size.should == 1
      end

      it "should get 2 reports for week" do
        get :index, :project_id => project , :namespace_id => namespace, :period => "week"
        assigns[:reports].size.should == 2
      end

      it "should get 3 reports for month" do
        get :index, :project_id => project , :namespace_id => namespace, :period => "month"
        assigns[:reports].size.should == 3
      end
    end
  end
end
