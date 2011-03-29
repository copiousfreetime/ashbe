require 'spec_helper'

describe Ashbe::Bytes do

  it "can round trip an Fixnum" do
    bytes = 12345.to_bytes
    i = Ashbe::Bytes.to_fixnum( bytes )
    puts i.class
    i.must_equal 12345
  end
  
  it "can round trip a Float" do
    bytes = (42.42).to_bytes
    f = Ashbe::Bytes.to_float( bytes )
    f.must_equal( 42.42 )

  end

  it "can round trip a string" do
    bytes = "the answer".to_bytes
    s = Ashbe::Bytes.to_string( bytes )
    s.must_equal "the answer"
  end

end
