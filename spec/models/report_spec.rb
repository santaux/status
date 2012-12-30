# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Report do
  let(:report) { FactoryGirl.create(:report) }
  let(:failed_report) { FactoryGirl.create(:failed_report) }

  it "should create report" do
    report.id.should_not be_nil
  end

  it "should be failed" do
    failed_report.failed?.should be_true
  end

  it "should not be failed" do
    report.failed?.should be_false
  end

  it "should return nil for filtered code for failed" do
    failed_report.filtered_code.should be_nil
  end

  it "should return code for filtered code" do
    report.filtered_code.should_not be_nil
  end

  context "scopes" do
    before(:each) do
      2.times do
        FactoryGirl.create(:report)
      end
      3.times do
        FactoryGirl.create(:failed_report)
      end
    end

    it "should have 5 reports" do
      Report.count.should == 5
    end

    it "should find 3 failed reports" do
      Report.failed.count.should == 3
    end

    it "should find 5 failed reports" do
      Report.by_period("day").count.should == 5
    end
  end
end

