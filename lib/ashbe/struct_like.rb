module Ashbe
  #
  # A module for use in classes that have hash like behavior and want to add in
  # method accessors for the keys.  
  #
  # This module requires that the extended class have the following methods:
  #
  # *  store( key, value)
  # *  fetch( key )
  # *  has_key?( key )
  #   
  module StructLike
    #
    # Allow for OpenStruct like access to the qualifier instances
    # via method missing
    #
    def method_missing( method, *args, &block )
      method = method.to_s
      case method
      when /=\Z/
        key = method.chomp('=')
        value = args.shift
        store( key, value )
      else
        key = method
        raise( IndexError, "Invalid accessor name '#{key}'" ) unless has_key?( key )
        value = fetch( key )
      end
      return value
    end
  end
end
