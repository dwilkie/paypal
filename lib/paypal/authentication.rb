module Paypal
  module Authentication
    require 'rack'
    include HTTParty
    private
      def authenticate_with_paypal_url(return_url)
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
        response = Paypal::Authentication.send_request(body)
        url = Paypal::Authentication.build_uri_from_set_auth_flow_param_response(response)
        url ? url : return_url
      end

      def get_auth_details(token)
        body = {
          "METHOD" => "GetAuthDetails",
          "VERSION" => "2.3",
          "USER" => Paypal.api_username,
          "PWD" => Paypal.api_password,
          "SIGNATURE" => Paypal.api_signature,
          "TOKEN" => token
        }
        Paypal::Authentication.normalize_paypal_response(
          Paypal::Authentication.send_request(body)
        )
      end

      def self.normalize_paypal_response(raw_response)
        raw_response_hash = Rack::Utils.parse_nested_query(raw_response)
        {
          :payer_id => raw_response_hash["PAYERID"],
          :first_name => raw_response_hash["FIRSTNAME"],
          :last_name => raw_response_hash["LASTNAME"],
          :email => raw_response_hash["EMAIL"]
        } if raw_response_hash["ACK"] == "Success"
      end

      def self.send_request(body)
        self.post(Paypal.nvp_uri, :body => body).body
      end

      def self.build_uri_from_set_auth_flow_param_response(response)
        if token = Rack::Utils.parse_nested_query(response)["TOKEN"]
          uri = URI.parse(Paypal.uri)
          uri.query = Rack::Utils.build_nested_query(
            "token" => token, "cmd" => "_account-authenticate-login"
          )
          uri.to_s
        end
      end
    end
end

