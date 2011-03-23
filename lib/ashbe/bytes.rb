require 'ashbe'

module Ashbe
  module Bytes
    def to_bytes( something )
      ::Ashbe::Java::Bytes.toBytes( something )
    end
    extend self
  end
end
