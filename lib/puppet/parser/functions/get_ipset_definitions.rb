module Puppet::Parser::Functions
    newfunction(:get_ipset_definitions) do |args|
        
        url = args[0]

        ipsets = get_ipsets_from_consul(url)

        ipset_definitions = {}

        ipsets.each do |ipsetName, ips| 
            ipset_definitions[ipsetName] = {
                "from_file" => "/opt/ipsets/#{ipsetName}",
                "ipset_type"=> "hash:net"
            }
        end 

        ipset_definitions
    end
 end