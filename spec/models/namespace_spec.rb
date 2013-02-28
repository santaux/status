# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Namespace do
  let(:namespace) { FactoryGirl.create(:namespace) }
  let(:project) { FactoryGirl.create(:project, :namespace => namespace) }

  before(:each) do
    @reports = []
    4.times do |i|
      @reports << FactoryGirl.create(:report, :project => project)
    end
    @reports << FactoryGirl.create(:failed_report, :project => project)
  end

  it "should create namespace" do
    namespace.id.should_not be_nil
  end

  it "should not create namespace with name which already exist" do
    same_namespace = FactoryGirl.build(:namespace, :name => namespace.name)
    same_namespace.save.should be_false
  end

  context "average methods" do
    it "should have correct uptime" do
      correct_uptime = (4.to_f/5)*100
      namespace.uptime.should == correct_uptime
    end

    it "should have correct average_delay_time" do
      correct_average_delay_time = namespace.projects.inject(0.0) { |sum,i|
        sum + i.average_delay_time('day').to_f
      }/namespace.projects.count
      ("%.4f" % namespace.average_delay_time).should == ("%.4f" % correct_average_delay_time)
    end

    it "should have correct average_response_time" do
      correct_average_response_time = namespace.projects.inject(0.0) { |sum,i|
        sum + i.average_response_time('day').to_f
      }/namespace.projects.count
      ("%.4f" % namespace.average_response_time ).should == ("%.4f" % correct_average_response_time)
    end
  end
end

