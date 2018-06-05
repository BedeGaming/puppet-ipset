Puppet::Type.newtype(:consulipsets) do
    desc "Puppet type that retrieves ipsets from consul and applies them"
  
    newparam(:url) do
        desc "Url for ipsets retrieval from Consul"
        defaultto "http://localhost:8500/v1/kv/config/bundle/ipsets"
    end

    newproperty(:ipsets) do
        desc "The ipsets themselves"
    end

    # newparam(:consul_address) do
    #     desc "Address of the Consul agent"
    #     defaultto "localhost"
    # end

    # newparam(:consul_protocol) do
    #     desc "Protocol to contact Consul agent API"
    #     newvalues(:http, :https)
    #     defaultto "http"
    # end
  
    # newparam(:consul_port) do
    #     desc "Port Consul agent runs on"
    #     newvalues(/^\d+$/)
    #     defaultto "8500"
    # end

    # newparam(:ipsets_key) do
    #     desc "Path to the ipsets key in Consul KV store"
    #     defaultto "config/bundle/ipsets"
    # end

    # newparam(:consul_api_version) do
    #     desc "Path to the ipsets key in Consul KV store"
    #     defaultto "v1"
    # end
end