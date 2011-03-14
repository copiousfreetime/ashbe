require 'spec_helper'

module Ashbe
  module Testing
    class Cluster
      def self.config_files
        Dir.glob( File.join( SPEC_DIR, "data/config", "*.xml" ) )
      end

      attr_reader :config

      def initialize
        @config  = ::Ashbe::Configuration.new( Cluster.config_files )
        @utility = org.apache.hadoop.hbase.HBaseTestingUtility.new( @config )
      end

      def start
        @utility.startMiniCluster
      end

      #
      # I still do not undestand how raising an exception can be the 'normal' flow
      # of work for this
      #
      def running?
        begin
          @utility.isRunningCluster( nil )
          return false
        rescue java.io.IOException => e
          if e.message =~ /Cluster already running/
            return true
          end
          return false
        end
      end

      def stop
        @utility.shutdownMiniCluster
      end
    end
  end
end

if $0 == __FILE__ then
  @cluster = Ashbe::Testing::Cluster.new
  @cluster.start
  puts "CLUSTER STARTED"
  trap 'INT' do
    @cluster.stop 
  end
end
