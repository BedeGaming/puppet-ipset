module Puppet::Parser::Functions
    newfunction(:validate_cidr, :type => :rvalue) do |args|
        
        cidr = [args[0]

        cidrSplit = cidr.split('/')
        is_ip_correct = !!(cidrSplit[0] =~ Resolv::IPv4::Regex)

        cidrSplit.length == 2 ? is_ip_correct && ((1..32).cover? cidrSplit[1].to_i) : is_ip_correct

    end
 end