require 'spec_helper'

describe Ashbe::AdminConnection do
  it "can connect to a server" do
    conn = ::Ashbe::AdminConnection.new( ::Ashbe::Configuration.new( spec_config_files ) )
    conn.connected?.must_equal true
  end
end
