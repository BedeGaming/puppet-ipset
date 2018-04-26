module Puppet::Parser::Functions
    newfunction(:get_ipsets_files) do |args|
        
        url = args[0]

        ipsets = get_ipsets_from_consul(url)

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