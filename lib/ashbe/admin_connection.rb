require 'ashbe'

module Ashbe
  class AdminConnection < ::Ashbe::Java::HBaseAdmin
    def initialize( config = Configuration.new )
      super( config )
    end

    #
    # Check and see if we are connected to the hbase cluster by asking for the
    # cluster status.  
    #
    # TODO: have a ClusterStatus object too.. ?
    #
    def connected?
      begin
        clusterStatus
        return true
      rescue => e
        return false
      end
    end

  end
end
