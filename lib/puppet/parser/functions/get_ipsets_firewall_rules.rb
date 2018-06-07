module Puppet::Parser::Functions
    newfunction(:get_ipsets_firewall_rules, :type => :rvalue) do |args|
        
        ipsets = args[0]

        ipset_firewall = {}

        ipsets.each do |ipsetName, ips| 
    
            priority = ipsetName.split("_")[2]
            
            ipset_firewall["#{priority} - #{ipsetName} Ipset"] = {
                "ipset" => "#{ipsetName} src",
                "action"=> "accept"
            }
        end 

        ipset_firewall
        
    end
 end