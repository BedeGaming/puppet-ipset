module Puppet::Parser::Functions
    newfunction(:get_ipsets_firewall_rules, :type => :rvalue) do |args|
        
        url = args[0]

        ipsets = function_get_ipsets_from_consul( [url] )

        ipset_firewall = {}

        ipsets.each do |ipsetName, ips| 
            ipset_firewall["888 - #{ipsetName} Ipset"] = {
                "ipset" => "#{ipsetName} src",
                "action"=> "accept"
            }
        end 

        ipset_firewall
        
    end
 end