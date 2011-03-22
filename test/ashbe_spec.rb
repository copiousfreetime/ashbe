require 'ashbe'

describe Ashbe do
  it "should have a version" do
    Ashbe::VERSION.must_match( %r|\A\d+\.\d+\.\d+\Z|  )
  end
end
