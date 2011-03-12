require 'minitest/spec'
require 'minitest/pride'
require 'ashbe'

describe Ashbe do
  it "should have a version" do
    Ashbe::VERSION.must_match /\d+\.\d+\.\d+/ 
  end
end
