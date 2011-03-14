require 'java'
module Ashbe
 module Java
   Path  = org.apache.hadoop.fs.Path
   JFile = java.io.File

   include_package 'org.apache.hadoop.hbase.client'

   HColumnDescriptor = org.apache.hadoop.hbase.HColumnDescriptor
   Compression       = org.apache.hadoop.hbase.io.hfile.Compression
 end
end
