# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Namespace do
  let(:namespace) { FactoryGirl.create(:namespace) }

  it "should create namespace" do
    namespace.id.should_not be_nil
  end

  it "should not create namespace with name which already exist" do
    same_namespace = FactoryGirl.build(:namespace, :name => namespace.name)
    same_namespace.save.should be_false
  end
end

