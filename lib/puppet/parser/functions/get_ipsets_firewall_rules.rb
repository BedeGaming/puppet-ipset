module Puppet::Parser::Functions
    newfunction(:get_ipsets_firewall_rules, :type => :rvalue) do |args|
        
        ipsets = args[0]

        ipset_firewall = {}

        ipsets.each do |ipsetName, ips| 
    
            isItDrop = (ipsetName.end_with? "drop")
        
            ipset_firewall["#{isItDrop ? "888" : "777"} - #{ipsetName} Ipset"] = {
                "ipset" => "#{ipsetName} src",
                "action"=> "accept"
            }
        end 

        ipset_firewall
        
    end
 end