require 'ashbe'

module Ashbe
  module Bytes
    def to_bytes( something )
      ::Ashbe::Java::Bytes.toBytes( something )
    end

    def to_string( bytes )
      ::Ashbe::Java::Bytes.toString( bytes )
    end

    #
    # Ruby fixnums, are backed by java Longs
    #
    def to_fixnum( bytes )
      ::Ashbe::Java::Bytes.toLong( bytes )
    end

    # We mean a ruby Float here, not a 4 byte IEEE float
    # In jruby, ruby Float objects are backed by java Doubles
    def to_float( bytes )
      ::Ashbe::Java::Bytes.toDouble( bytes )
    end

    extend self
  end
end
