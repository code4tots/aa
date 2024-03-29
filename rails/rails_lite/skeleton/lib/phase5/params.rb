require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    def initialize(req, route_params = {})
      @params = route_params.
        merge(parse_www_encoded_form(req.query_string)).
        merge(parse_www_encoded_form(req.body))
    end
    
    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      return Hash.new if www_encoded_form.nil?
      hash = Hash.new
      URI::decode_www_form(www_encoded_form).each do |key, value|
        p = nil
        h = hash
        subkeys = parse_key(key)
        subkeys.each do |subkey|
          h[subkey] = Hash.new unless h.include?(subkey)
          p = h
          h = h[subkey]
        end
        p[subkeys[-1]] = value
      end
      hash
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split /\]\[|\[|\]/
    end
  end
end
