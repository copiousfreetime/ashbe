require 'ashbe'
class Object
  def to_bytes
    ::Ashbe::Bytes.to_bytes( self )
  end
end
