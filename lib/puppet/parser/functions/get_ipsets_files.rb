module Puppet::Parser::Functions
    newfunction(:get_ipsets_files, :type => :rvalue) do |args|
        
        ipsets = args[0]

        ipset_files = {}

        ipsets.each do |ipsetName, ips| 
            ipset_files["/opt/ipsets/#{ipsetName}.zone"] = {
                "ensure"    => "file",
                "owner"     => "root",
                "group"     => "root",
                "mode"      => "0755",
                "content"   => ips
            }
        end
        
        ipset_files

    end
 end