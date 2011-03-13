require 'spec_helper'

describe Ashbe::Configuration do
  it "loads a configuration" do
    c = ::Ashbe::Configuration.new( spec_config_files )
    c['hbase.regionserver.handler.count'].must_equal "5"
  end
end
