require 'multi_json'

module SageOne
  # This helper methods in this module are used by the public api methods.
  # They use the Faraday::Connection defined in connection.rb for making
  # requests. Setting 'SageOne.raw_response' to true can help with debugging.
  # @api private
  module Request
    def delete(path, options={})
      request(:delete, path, options)
    end

    def get(path, options={})
      request(:get, path, options)
    end

    def post(path, options={})
      request(:post, path, options)
    end

    def put(path, options={})
      request(:put, path, options)
    end

    private


    def request(method, path, options)

      response = connection.send(method) do |request|

        params_string = get_params_string(options)
        case method
        when :delete, :get
          options.merge!('$startIndex' => options.delete(:start_index)) if options[:start_index]
          request.url(api_endpoint + path, options)

        when :post, :put
          request.path = path
          request.body = params_string
        end

        nonce = CGI.escape(SecureRandom.urlsafe_base64)
        request.headers['X-Nonce'] = nonce
        request.headers['Accept'] = "*/*"
        request.headers["Content-Type"] = "application/x-www-form-urlencoded"
        
        request.headers['X-Signature'] = get_sig(get_signing_key, get_base_string(method, path, params_string, nonce))
        # if X-Signature is not correct, the response will be a 401 Unauthorized error

      end


      if raw_response
        response
      elsif auto_traversal && ( next_url = links(response)["next"] )
        response.body + request(method, next_url, options)
      else
        response.body
      end
    end

    def links(response)
      links = ( response.headers["X-SData-Pagination-Links"] || "" ).split(', ').map do |link|
        url, type = link.match(/<(.*?)>; rel="(\w+)"/).captures
        [ type, url ]
      end

      Hash[ *links.flatten ]
    end

    # not being used currently
    def format_datelike_objects!(options)
      new_opts = {}
      options.map do |k,v|
        if v.respond_to?(:map)
          new_opts[k] = format_datelike_objects!(v)
        else
          new_opts[k] = v.respond_to?(:strftime) ? v.strftime("%d/%m/%Y") : v
        end
      end
      new_opts
    end


    # The following methods are used to create a signature for each request

    def get_params_string(parms)
      string = Faraday::Utils.build_nested_query(parms)
      string.gsub!("+", "%20")
      # Sage requires all +'s to be encoded

      string.gsub!("line_items_attributes%5D%5B%5D", "line_items_attributes%5D%5B0%5D")
      # replaces ][] with ][0]  (SPECIFICALLY for posting invoices with 1 line item)
      # for example:
      # sales_invoice[line_items_attributes][][attr] will always need to be
      # sales_invoice[line_items_attributes][0][attr]

      string
    end

    def get_signing_key
      string = CGI.escape(signing_secret) + '&' + CGI.escape(access_token)
    end

    def get_base_string(method, endpoint, params_string, nonce)
      string = method.to_s.upcase + '&'
      string += CGI.escape(api_endpoint + endpoint) + '&'
      string += CGI.escape(params_string) + '&'
      string += nonce
      string
    end

    def get_sig(signing_key, base_string)
      digest = OpenSSL::Digest.new('sha1')
      hmac = OpenSSL::HMAC.digest(digest, signing_key, base_string)
      sig = Base64.strict_encode64(hmac)
    end

  end
end
