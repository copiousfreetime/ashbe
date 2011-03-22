#
# Ashbe is a library that wraps the HBase client library with Ruby style.
#
# Ashbe requires the use of the HBase jars and all the dependencies of them.
# The Java module encapsulates all the logic about the java portion of the
# system.
#
# All on its own, Ashbe knows nothing of the wherebouts of the HBase jars. It
# must be told about it from the beginning.
#
# Before using the Ashbe library there is a bit of java setup to do. Ashbe
# must be made aware of the HBase jars and all the dependendt jars. The
# easiest way to do this is if all the jars are in a director tree and the
# just do:
#
#     Ashbe.initialize( "directory/to/jars" )
#
module Ashbe
  VERSION = '1.0.0'

  class Error < ::StandardError; end

  def self.jars
    @jars ||= []
  end
  #
  # Use the jar at the given path.
  #
  def self.use_jar( jar )
    jars << jar
  end

  #
  # Use all the jars in the given list.  The list is assumed to be a list of
  # filenames.
  #
  def self.use_jars( list )
    list.flatten.each { |jar| use_jar( jar ) }
  end

  #
  # Use all the jars in the given directory tree, recursively.
  #
  def self.use_jars_in( dir )
    puts "using jars in #{dir}"
    use_jars( Dir.glob(  "#{dir}/**/*.jar" ) )
  end

  #
  # Require all the jars that Ashbe knows about
  #
  def self.require_jars
    jars.each { |jar| require File.expand_path( jar ) }
  end

  #
  # require all the jars so that the library may be used
  #
  def self.initialize( *locations )
    locations.flatten.each do |location|
      if File.extname( location ) == ".jar" then
        use_jar( location )
      else
        use_jars_in( location )
      end
    end

    require_jars
    require_lib
  end

  #
  # Require all the sub components of the Asbhe library
  #
  def self.require_lib
    require 'ashbe/java'
    require 'ashbe/bytes'
    require 'ashbe/cell'
    require 'ashbe/configuration'
    require 'ashbe/admin_connection'
    require 'ashbe/table_connection'
    require 'ashbe/table'
    require 'ashbe/qualifier'
    require 'ashbe/column_family'
    require 'ashbe/compression'
  end


end

