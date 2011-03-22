require 'spec_helper'

describe Ashbe::Row do
  it "Has a key" do
    row = Ashbe::Row.new( 12345 )
    row.key.must_equal 12345
  end

end
