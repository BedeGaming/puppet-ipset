# Define: consulipsets
#
# Retrieve the ipsets from Consul
# It relies on the config in Consul having a specific stucture
#
# Parameters:
#  $consul_url:
#    Url to retrieve from consul. Default: none
#
# Sample Usage:
#  consulipsets { 'all':
#    consul_url => 'http://localhost:1234/v1/kv/configkey',
#  }
#
define ipset::consulipsets (
  $url = ""
) {
    include firewall

    $ipsets = get_ipsets_from_consul($consul_url)

    # get file resources out of the ipsest hash
    $ipset_files = get_ipsets_files($ipsets)

    # create the ipset files
    create_resources('file', $ipset_files)

    # get ipset resources out of the ipsest hash
    $ipset_definitions = get_ipsets_definitions($ipsets)

    # create the ipsets themselves
    create_resources('ipset', $ipset_definitions)

    # get firewall resources out of the ipsest hash
    $ipset_firewall_rules = get_ipsets_firewall_rules($ipsets)
    
    # create the iptables entries
    create_resources('firewall', $ipset_firewall_rules)

  }
