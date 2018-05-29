module Puppet::Parser::Functions
    newfunction(:get_ipsets_definitions, :type => :rvalue) do |args|
        
        ipsets = args[0]

        ipset_definitions = {}

        ipsets.each do |ipsetName, ips| 
            ipset_definitions[ipsetName] = {
                "from_file" => "/opt/ipsets/#{ipsetName}.zone",
                "ipset_type"=> "hash:net"
            }
        end 

        ipset_definitions
    end
 end