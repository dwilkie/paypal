module Paypal
  module Authentication
    require 'rack'
    include HTTParty
    private
      def paypal_url(return_url)
        body = {
          "METHOD" => "SetAuthFlowParam",
          "VERSION" => "2.3",
          "USER" => Paypal.api_username,
          "PWD" => Paypal.api_password,
          "SIGNATURE" => Paypal.api_signature,
          "SERVICENAME1" => "Name",
          "SERVICEDEFREQ1" => "Required",
          "SERVICENAME2" => "Email",
          "SERVICEDEFREQ2" => "Required",
          "RETURNURL" => return_url,
          "CANCELURL" => return_url,
          "LOGOUTURL"=> return_url
        }
        request_uri = URI.parse(Paypal.nvp_uri)
        request_uri.scheme = "https" # force https
        response = self.post(request_uri.to_s, :body => body).body
        Paypal::Authentication.build_uri_from_set_auth_flow_param_response(response)
      end

      def self.build_uri_from_set_access_permissions_response(response)
        token = Rack::Utils.parse_nested_query(response)["TOKEN"]
        uri = URI.parse(Paypal.uri)
        query_hash = {
          "cmd" => "_account-authenticate-login",
          "token" => token
        }
        uri.query = Rack::Utils.build_nested_query(query_hash)
        uri.to_s
      end
    end
end

