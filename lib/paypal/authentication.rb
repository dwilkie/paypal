module Paypal
  module Authentication
    require 'rack'
    include HTTParty
    class Response
      attr_reader :raw_response
      attr_reader :raw_response_hash

      def initialize(raw_response)
        @raw_response = raw_response
        @raw_response_hash = Rack::Utils.parse_query(raw_response)
      end

      def success?
        ack == "Success"
      end

      def failure?
        ack == "Failure"
      end

      def ack
        raw_response_hash["ACK"]
      end

      def long_error_message
        raw_response_hash["L_LONGMESSAGE0"]
      end

      def short_error_message
        raw_response_hash["L_SHORTMESSAGE0"]
      end

      def error_code
        raw_response_hash["L_ERRORCODE0"]
      end

      def timestamp
        raw_response_hash["TIMESTAMP"]
      end

      def correlation_id
        raw_response_hash["CORRELATIONID"]
      end

      def severity_code
        raw_response_hash["L_SEVERITYCODE0"]
      end

      def build
        raw_response_hash["BUILD"]
      end

      def version
        raw_response_hash["VERSION"]
      end
    end

    class SetAuthFlowParamResponse < Response
      def token
        raw_response_hash["TOKEN"]
      end
    end

    class GetAuthDetailsResponse < Response
      def user_details
        {
          :payer_id => raw_response_hash["PAYERID"],
          :first_name => raw_response_hash["FIRSTNAME"],
          :last_name => raw_response_hash["LASTNAME"],
          :email => raw_response_hash["EMAIL"]
        }
      end
    end

    private
      def remote_authentication_url(token)
        Paypal::Authentication.remote_authentication_url(token)
      end

      def set_auth_flow_param!(return_url)
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
        Paypal::Authentication::SetAuthFlowParamResponse.new(
          Paypal::Authentication.send_request(body)
        )
      end

      def get_auth_details!(token)
        body = {
          "METHOD" => "GetAuthDetails",
          "VERSION" => "2.3",
          "USER" => Paypal.api_username,
          "PWD" => Paypal.api_password,
          "SIGNATURE" => Paypal.api_signature,
          "TOKEN" => token
        }
        Paypal::Authentication::GetAuthDetailsResponse.new(
          Paypal::Authentication.send_request(body)
        )
      end

      def get_token_from_query_params(query_params)
        query_params["token"]
      end

      def self.send_request(body)
        self.post(Paypal.nvp_uri, :body => body).body
      end

      def self.remote_authentication_url(token)
        uri = URI.parse(Paypal.uri)
        uri.query = Rack::Utils.build_nested_query(
          "token" => token, "cmd" => "_account-authenticate-login"
        )
        uri.to_s
      end
    end
end

