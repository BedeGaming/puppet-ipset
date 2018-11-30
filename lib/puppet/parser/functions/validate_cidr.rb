module Puppet::Parser::Functions
    newfunction(:validate_cidr, :type => :rvalue) do |args|
        
        require "resolv"

        cidr = args[0]

        cidrSplit = cidr.split('/')
        is_ip_correct = !!(cidrSplit[0] =~ Resolv::IPv4::Regex)

        is_cidr_correct = false
        
        if cidrSplit.length == 1 then is_cidr_correct = is_ip_correct end
        if cidrSplit.length == 2 then is_cidr_correct = is_ip_correct && ((1..32).cover? cidrSplit[1].to_i) end
        
        is_cidr_correct

    end
 end