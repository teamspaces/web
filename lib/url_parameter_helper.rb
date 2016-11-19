module UrlParameterHelper

    def parameter_value(url, param_key)
      query_params = URI(url).query
      URI::decode_www_form(query_params).to_h[param_key] if query_params
    end

    def add_parameter_to_url(url, param_key, param_value)
      uri =  URI.parse(url)
      params = [[param_key, param_value]]
      params = URI.decode_www_form(uri.query) << [param_key, param_value] if uri.query
      uri.query = URI.encode_www_form(params)
      uri.to_s
    end

    def remove_parameter_from_url(url, param_key)
      uri =  URI.parse(url)
      params = URI.decode_www_form(uri.query)
      params.delete_if { |parameter| parameter[0] == param_key }
      uri.query = URI.encode_www_form(params)
      uri.to_s
    end
end
