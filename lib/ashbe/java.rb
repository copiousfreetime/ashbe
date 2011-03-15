require 'java'
module Ashbe
 module Java

   # general java classes
   JFile = java.io.File


   # Hadoop classes we need
   Path  = org.apache.hadoop.fs.Path


   # HBase specific classes
   Bytes             = org.apache.hadoop.hbase.util.Bytes
   HTableDescriptor  = org.apache.hadoop.hbase.HTableDescriptor
   HColumnDescriptor = org.apache.hadoop.hbase.HColumnDescriptor
   Compression       = org.apache.hadoop.hbase.io.hfile.Compression


   # and all of client, since that is what this library basically wraps
   include_package 'org.apache.hadoop.hbase.client'
 end
end
