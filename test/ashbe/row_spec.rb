require 'spec_helper'

describe Ashbe::Row do
  before do
    @data = { 'foo' => { 'one'    => '1', 'two' => '2' },
              'bar' => { 'four'   => '4', 'six' => '6' },
              'baz' => { 'wibble' => 'a' } }
  end
end
