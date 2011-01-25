module Paypal
  module TestHelpers
    module Authentication

      def paypal_authentication_token_query_hash(token = nil)
        token ||= sample_paypal_authentication_token
        {"token" => token}
      end

      def sample_paypal_user_details
        {
          :payer_id => "QDK7VE2WTVHLQ",
          :first_name => "Michael",
          :last_name => "Jackson",
          :email => "michael_jackson@hotmail.com"
         }
      end

      def sample_paypal_authentication_token
        "HA-QBUBK9F4R7GWL"
      end

      def sample_get_auth_details_response(mock_user_details = nil, error = nil)
        raise(
          ArgumentError, "mock user details must be a hash of paypal user details. See sample_paypal_user_details for an example"
        ) if mock_user_details && !mock_user_details.is_a?(Hash)

        mock_user_details ||= sample_paypal_user_details
        error_type = :token_expired if error == true

        if error_type
          if error_type == :token_expired
            response_body = "TIMESTAMP=2011%2d01%2d25T15%3a44%3a11Z&CORRELATIONID=c281d76b35cc3&ACK=Failure&VERSION=2%2e3&BUILD=1646991&L_ERRORCODE0=10062&L_SHORTMESSAGE0=The%20token%20has%20expired%2e&L_LONGMESSAGE0=The%20token%20has%20expired%2e%20For%20a%20new%20token%2c%20make%20the%20API%20call%20again%2e&L_SEVERITYCODE0=Error"
          elsif error_type == :user_does_not_exist
            response_body = "TIMESTAMP=2011%2d01%2d25T15%3a48%3a00Z&CORRELATIONID=b20f7162d00d8&ACK=Failure&VERSION=2%2e3&BUILD=1646991&L_ERRORCODE0=11622&L_SHORTMESSAGE0=User%20Does%20Not%20Exist%2e&L_LONGMESSAGE0=User%20may%20not%20have%20logged%20in%20using%20this%20token%2e&L_SEVERITYCODE0=Error"
          else
            raise ArgumentError, "The error: '#{error_type}' is unknown"
          end
          response_body
        else
          body_template = "TIMESTAMP=2011%2d01%2d25T15%3a43%3a54Z&CORRELATIONID=a15ba16a74b7f&ACK=Success&VERSION=2%2e3&BUILD=1646991"
          parsed_paypal_user_details = {}
          paypal_user_details.each do |key, value|
            parsed_paypal_user_details[key.classify.upcase] = value
          end
          paypal_user_details = parsed_paypal_user_details
          paypal_response = Rack::Utils.parse_query(body_template)
          paypal_response.merge!(paypal_user_details)
          Rack::Utils.build_query(paypal_response)
        end
      end

      def sample_set_auth_flow_param_response(error = nil)
        error_type = :timeout if error == true

        if error_type
          if error_type == :timeout
            response_body = "TIMESTAMP=2011%2d01%2d23T17%3a31%3a21Z&CORRELATIONID=3dffbd94a827d&ACK=Failure&L_ERRORCODE0=10001&L_SHORTMESSAGE0=Internal%20Error&L_LONGMESSAGE0=Timeout%20processing%20request"
          else
            raise ArgumentError, "The error: '#{error_type}' is unknown"
          end
          response_body
        else
          body_template = "TIMESTAMP=2011%2d01%2d23T11%3a11%3a00Z&CORRELATIONID=de856e13337e2&ACK=Success&VERSION=2%2e3&BUILD=1646991"
          paypal_response = Rack::Utils.parse_query(body_template)
          paypal_response.merge!("TOKEN" => sample_paypal_authentication_token)
          Rack::Utils.build_query(paypal_response)
        end
      end
    end
  end
end

