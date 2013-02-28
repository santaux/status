# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Project do
  let(:namespace) { FactoryGirl.create(:namespace) }
  let(:project) { FactoryGirl.create(:project, :namespace => namespace) }

  before(:each) do
    @reports = []
    4.times do |i|
      @reports << FactoryGirl.create(:report, :project => project)
    end
    @reports << FactoryGirl.create(:failed_report, :project => project)
  end

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
      project.reports.count.should be_equal(5)
    end
  end

  context "average methods" do
    it "should have correct uptime" do
      correct_uptime = (4.to_f/5)*100
      project.uptime.should == correct_uptime
    end

    # it works fine with sqlite, but has infelicity with postgres:
    pending "should have correct average_delay_time" do
      correct_average_delay_time = @reports.inject(0.0) { |sum,r| sum + r.delay_time }/5
      ("%.6f" % project.average_delay_time).should == ("%.6f" % correct_average_delay_time)
    end

    # it works fine with sqlite, but has infelicity with postgres:
    pending "should have correct average_response_time" do
      correct_average_response_time = @reports.inject(0.0) { |sum,r| sum + r.response_time }/5
      ("%.6f" % project.average_response_time ).should == ("%.6f" % correct_average_response_time)
    end
  end

  context "group methods" do
    describe "response time" do
      it "should have 1 grouped report for day period" do
        project.reports_grouped_response_time("day").size.should == 1
      end

      it "should stil have 1 grouped report for day period" do
        rep = FactoryGirl.create(:report, :project => project)
        rep.update_attribute(:created_at, Time.now - 2.days)
        project.reports_grouped_response_time("day").size.should == 1
      end

      # for day period it groups them by hour
      it "should have 2 grouped reports for day period" do
        rep = FactoryGirl.create(:report, :project => project)
        rep.update_attribute(:created_at, Time.now - 2.hours)
        project.reports_grouped_response_time("day").size.should == 2
      end

      # for week period it groups them by day
      it "should have 3 grouped reports for week period" do
        2.times do |i|
          i = i+1
          rep = FactoryGirl.create(:report, :project => project)
          rep.update_attribute(:created_at, Time.now - i.days)
        end
        project.reports_grouped_response_time("week").size.should == 3
      end

      # for month period it groups them by day
      it "should have 4 grouped reports for month period" do
        3.times do |i|
          i = i+1
          rep = FactoryGirl.create(:report, :project => project)
          rep.update_attribute(:created_at, Time.now - i.weeks)
        end
        project.reports_grouped_response_time("month").size.should == 4
      end

      # for year period it groups them by month
      it "should have 5 grouped reports for year period" do
        4.times do |i|
          i = i+1
          rep = FactoryGirl.create(:report, :project => project)
          rep.update_attribute(:created_at, Time.now - i.months)
        end
        project.reports_grouped_response_time("year").size.should == 5
      end
    end

    describe "delay time" do
      it "should have 1 grouped report for day period" do
        project.reports_grouped_delay_time("day").size.should == 1
      end

      it "should stil have 1 grouped report for day period" do
        rep = FactoryGirl.create(:report, :project => project)
        rep.update_attribute(:created_at, Time.now - 2.days)
        project.reports_grouped_delay_time("day").size.should == 1
      end

      # for day period it groups them by hour
      it "should have 2 grouped reports for day period" do
        rep = FactoryGirl.create(:report, :project => project)
        rep.update_attribute(:created_at, Time.now - 2.hours)
        project.reports_grouped_delay_time("day").size.should == 2
      end

      # for week period it groups them by day
      it "should have 3 grouped reports for week period" do
        2.times do |i|
          i = i+1
          rep = FactoryGirl.create(:report, :project => project)
          rep.update_attribute(:created_at, Time.now - i.days)
        end
        project.reports_grouped_delay_time("week").size.should == 3
      end

      # for month period it groups them by day
      it "should have 4 grouped reports for month period" do
        3.times do |i|
          i = i+1
          rep = FactoryGirl.create(:report, :project => project)
          rep.update_attribute(:created_at, Time.now - i.weeks)
        end
        project.reports_grouped_delay_time("month").size.should == 4
      end

      # for year period it groups them by month
      it "should have 5 grouped reports for year period" do
        4.times do |i|
          i = i+1
          rep = FactoryGirl.create(:report, :project => project)
          rep.update_attribute(:created_at, Time.now - i.months)
        end
        project.reports_grouped_delay_time("year").size.should == 5
      end
    end

    describe "uptime" do
      it "should have 1 grouped report for day period" do
        project.reports_grouped_uptime("day").size.should == 1
      end

      it "should stil have 1 grouped report for day period" do
        rep = FactoryGirl.create(:report, :project => project)
        rep.update_attribute(:created_at, Time.now - 2.days)
        project.reports_grouped_uptime("day").size.should == 1
      end

      # for day period it groups them by hour
      it "should have 2 grouped reports for day period" do
        rep = FactoryGirl.create(:report, :project => project)
        rep.update_attribute(:created_at, Time.now - 2.hours)
        project.reports_grouped_uptime("day").size.should == 2
      end

      # for week period it groups them by day
      it "should have 3 grouped reports for week period" do
        2.times do |i|
          i = i+1
          rep = FactoryGirl.create(:report, :project => project)
          rep.update_attribute(:created_at, Time.now - i.days)
        end
        project.reports_grouped_uptime("week").size.should == 3
      end

      # for month period it groups them by day
      it "should have 4 grouped reports for month period" do
        3.times do |i|
          i = i+1
          rep = FactoryGirl.create(:report, :project => project)
          rep.update_attribute(:created_at, Time.now - i.weeks)
        end
        project.reports_grouped_uptime("month").size.should == 4
      end

      # for year period it groups them by month
      it "should have 5 grouped reports for year period" do
        4.times do |i|
          i = i+1
          rep = FactoryGirl.create(:report, :project => project)
          rep.update_attribute(:created_at, Time.now - i.months)
        end
        project.reports_grouped_uptime("year").size.should == 5
      end
    end
  end

  context "ping method" do
    before(:each) do
      WebMock.disable_net_connect!
      project.update_attribute(:host, "http://www.google.com")
    end

    describe "on success" do
      before(:each) do
        stub_request(:get, "http://www.google.com").to_return(:body => "I'm google", :status => [200, "OK"], :headers => { 'Content-Length' => 3000 })
      end

      it "should return successed status" do
        project.ping[:code].should == 200
      end

      it "should have response and deplay time" do
        ping = project.ping
        ping[:delay_time].should_not be_zero
        ping[:response_time].should_not be_zero
      end

      it "should have response time greater that delay time" do
        ping = project.ping
        ping[:delay_time].should < ping[:response_time]
      end
    end

    describe "on server error" do
      before(:each) do
        stub_request(:get, "http://www.google.com").to_return(:status => [500, "Internal Server Error"])
      end

      it "should return zero status" do
        project.ping[:code].should == 500
      end

      it "should return error message" do
        project.ping[:message].should == "Internal Server Error"
      end

      it "should not have zero response and deplay time" do
        ping = project.ping
        puts ping.inspect
        ping[:delay_time].should_not be_zero
        ping[:response_time].should_not be_zero
      end
    end

    describe "on timeout" do
      before(:each) do
        stub_request(:get, "http://www.google.com").to_timeout
      end

      it "should return zero status" do
        project.ping[:code].should == 0
      end

      it "should return timeout message" do
        project.ping[:message].should == "execution expired"
      end

      it "should have zero response and deplay time" do
        ping = project.ping
        ping[:delay_time].should be_zero
        ping[:response_time].should be_zero
      end
    end
  end
end

