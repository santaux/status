# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Main page", :type => :request do
  before :each do
    3.times do
      FactoryGirl.create(:namespace)
    end
    Namespace.all.each do |namespace|
      6.times do
        FactoryGirl.create(:project, :namespace => namespace)
      end
    end
    Project.all.each do |project|
      5.times do
        FactoryGirl.create(:report, :project => project)
      end
    end
  end

  before(:each) do
    visit root_path
  end

  context "namespaces" do
    it "should have tabs namspaces" do
      page.should have_css('ul.nav.nav-tabs.namespaces li a')
    end

    it "should have 3 tabs namspaces" do
      Namespace.all.each do |ns|
        page.should have_content(ns.name.humanize)
      end
    end

    it "one of the tabs should be active" do
      page.should have_css('ul.nav.nav-tabs.namespaces li.active a')
    end

    it "should have average namespace data" do
      namespace = Namespace.first
      Project::PERIODS.each do |period|
        page.should have_content(namespace.uptime(period).to_s[0..5])
        page.should have_content(namespace.average_delay_time(period).to_s[0..5])
        page.should have_content(namespace.average_response_time(period).to_s[0..5])
      end
    end
  end

  context "project" do
    it "should have tabs projects" do
      page.should have_css('ul.nav.nav-pills.projects li a')
    end

    it "should have tabs projects for first namespace" do
      Namespace.first.projects.each do |pr|
        page.should have_content(pr.name.humanize)
      end
    end

    it "one of the tabs should be active" do
      page.should have_css('ul.nav.nav-pills.projects li.active a')
    end

    it "should have average project data" do
      project = Namespace.first.projects.first
      page.should have_content(project.uptime.to_s[0..5])
      page.should have_content(project.average_delay_time.to_s[0..5])
      page.should have_content(project.average_response_time.to_s[0..5])
    end
  end
end
