# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Project do
  let(:namespace) { FactoryGirl.create(:namespace) }
  let(:project) { FactoryGirl.create(:project, :namespace => namespace) }

  context "records creating" do
    it "should create project" do
      project.id.should_not be_nil
    end

    it "should not create project with same host and name" do
      same_name_proj = FactoryGirl.build(:project, :name => project.name)
      same_host_proj = FactoryGirl.build(:project, :host => project.host)
      same_name_proj.save.should be_false
      same_host_proj.save.should be_false
    end

    it "should have 5 reports" do
      5.times do |i|
        FactoryGirl.create(:report, :project => project)
      end

      project.reports.count.should be_equal(5)
    end
  end

  context "average methods" do
    before(:each) do
      @reports = []
      4.times do |i|
        @reports << FactoryGirl.create(:report, :project => project)
      end
      @reports << FactoryGirl.create(:failed_report, :project => project)
    end

    it "should have correct uptime" do
      correct_uptime = (4.to_f/5)*100
      project.uptime.should == correct_uptime
    end

    it "should have correct average_delay_time" do
      correct_average_delay_time = @reports.inject(0.0) { |sum,r| sum + r.delay_time }/5
      ("%.4f" % project.average_delay_time).should == ("%.4f" % correct_average_delay_time)
    end

    it "should have correct average_response_time" do
      correct_average_response_time = @reports.inject(0.0) { |sum,r| sum + r.response_time }/5
      ("%.4f" % project.average_response_time ).should == ("%.4f" % correct_average_response_time)
    end
  end
end

