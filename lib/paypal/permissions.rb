module Paypal
  module Permissions
    require 'rack'
    include HTTParty
    private
      def set_paypal_permissions_url(return_url, required_permissions = {})
        required_permissions.merge!(:name => true, :email => true)
        paypal_required_permissions = {}
        index = 0
        required_permissions.each do |k,v|
          if v
            paypal_required_permissions["L_REQUIREDACCESSPERMISSIONS#{index}"] = Paypal::Permissions.permission_name(k)
            index += 1
          end
        end
        body = {
          "METHOD" => "SetAccessPermissions",
          "VERSION" => "2.3",
          "USER" => Paypal.api_username,
          "PWD" => Paypal.api_password,
          "SIGNATURE" => Paypal.api_signature,
          "RETURNURL" => return_url,
          "CANCELURL" => return_url,
          "LOGOUTURL"=> return_url
        }.merge(paypal_required_permissions)
        request_uri = URI.parse(Paypal.nvp_uri)
        request_uri.scheme = "https" # force https
        response = Paypal::Permissions.set_access_permissions(request_uri.to_s, body)
        url = Paypal::Permissions.build_uri_from_set_access_permissions_response(response)
        url ? url : return_url
      end

      def self.set_access_permissions(request_uri, body)
        self.post(request_uri, :body => body).body
      end

      def self.permission_name(key)
        case key.to_s

        when "express_checkout"
          "Express_Checkout"

        when "admin_api"
          "Admin_API"

        when "auth_settle"
          "Auth_Settle"

        when "transaction_history"
          "Transaction_History"

        when "do_uatp_authorization"
          "DoUATPAuthorization"

        when "do_uatp_express_checkout_payment"
          "DoUATPExpressCheckoutPayment"

        else
          camelize(key)
        end
      end

      def self.build_uri_from_set_access_permissions_response(response)
        if token = Rack::Utils.parse_nested_query(response)["TOKEN"]
          uri = URI.parse(Paypal.uri)
          uri.query = Rack::Utils.build_nested_query(
            "token" => token, "_cmd" => "_access-permission-login"
          )
          uri.to_s
        end
      end

      def self.camelize(lower_case_and_underscored_word)
        lower_case_and_underscored_word.to_s.gsub(/(?:^|_)(.)/) { $1.upcase }
      end
    end
end

