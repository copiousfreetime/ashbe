require 'spec_helper'

describe Ashbe::Compression do

  it "knows how many algorithms there are" do
    Ashbe::Compression.algorithms.size.must_equal 3
  end

  it "can lookup up an algorithm by symbol" do
    Ashbe::Compression.algorithm_for( :lzo ).name.must_equal "LZO"
    Ashbe::Compression.algorithm_for( :lzo ).must_equal org.apache.hadoop.hbase.io.hfile.Compression::Algorithm::LZO
  end

  it "knows compression algorithsm by constant" do
    Ashbe::Compression::LZO.name.must_equal "LZO"
  end
end
