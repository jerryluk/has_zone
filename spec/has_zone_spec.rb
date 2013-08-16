require 'spec_helper'

describe HasZone do
  class Resource
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks
    include HasZone
    attr_accessor :time_zone
    has_zone with: :time_zone

    def write_attribute(attribute, value)
      instance_variable_set("@#{attribute}".to_sym, value)
    end
  end

  let(:resource) { Resource.new }

  it "returns nil if time_zone is nil" do
    resource.time_zone = nil
    resource.zone.should be_nil
  end

  it "returns TimeZone if time_zone is not nil" do
    resource.time_zone = "America/New_York"
    resource.zone.should_not be_nil
  end

  it "returns updated TimeZone if time_zone is updated" do
    resource.time_zone = "America/New_York"
    expect {
      resource.time_zone = "America/Los_Angeles"
    }.to change(resource, :zone)
  end

  it "sets TimeZone from string" do
    resource.zone = "Pacific Time (US & Canada)"
    resource.zone.should == ActiveSupport::TimeZone.new("Pacific Time (US & Canada)").name
    resource.time_zone.should == "America/Los_Angeles"
  end

  it "sets TimeZone from TimeZone" do
    zone = ActiveSupport::TimeZone.new("Pacific Time (US & Canada)")
    resource.zone = zone
    resource.zone.should == "Pacific Time (US & Canada)"
    resource.time_zone.should == "America/Los_Angeles"
  end

  it "sets UTC time zone to Etc/UTC" do
    resource.time_zone = "UTC"
    resource.should be_valid
    resource.time_zone.should == "Etc/UTC"
  end

end
