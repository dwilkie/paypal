module Paypal
  module TestHelpers
    module Authentication
      def paypal_authentication_token_query_hash(token = nil)
        token ||= sample_paypal_authentication_token
        {"token" => token}
      end

      def sample_paypal_authentication_token
        "HA-QBUBK9F4R7GWL"
      end

      def sample_set_auth_flow_param_response(error = nil)
        error_type = :timeout if error == true

        if error_type
          if error_type == :timeout
            response_body = "TIMESTAMP=2011%2d01%2d23T17%3a31%3a21Z&CORRELATIONID=3dffbd94a827d&ACK=Failure&L_ERRORCODE0=10001&L_SHORTMESSAGE0=Internal%20Error&L_LONGMESSAGE0=Timeout%20processing%20request"
          else
            raise "The error: '#{error_type}' is unknown"
          end
          response_body
        else
          response_body = "TIMESTAMP=2011%2d01%2d23T11%3a11%3a00Z&CORRELATIONID=de856e13337e2&ACK=Success&VERSION=2%2e3&BUILD=1646991"
          paypal_response = Rack::Utils.parse_query(response_body)
          paypal_response.merge!("TOKEN" => sample_paypal_authentication_token)
          Rack::Utils.build_query(paypal_response)
        end
      end
    end
  end
end

