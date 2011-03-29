require 'spec_helper'

describe Ashbe::BytesConversion do

  it "can round trip an Fixnum" do
    bytes = 12345.to_bytes
    bytes.extend( Ashbe::FromBytes )
    i = bytes.to_fixnum
    i.must_equal 12345
  end
  
  it "can round trip a Float" do
    bytes = (42.42).to_bytes
    bytes.extend( Ashbe::FromBytes )
    f = bytes.to_float
    f.must_equal( 42.42 )

  end

  it "can round trip a string" do
    bytes = "the answer".to_bytes
    bytes.extend( Ashbe::FromBytes )
    s = bytes.to_string
    s.must_equal "the answer"
  end

end
