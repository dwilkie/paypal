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
            paypal_required_permissions["L_REQUIREDACCESSPERMISSIONS#{index}"] = Paypal::Permissions.paypal_permission_name(k)
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
        response = Paypal::Permissions.send_request(body)
        url = Paypal::Permissions.build_uri_from_set_access_permissions_response(response)
        url ? url : return_url
      end

      def get_paypal_permissions(token)
        body = {
          "METHOD" => "GetAccessPermissionDetails",
          "VERSION" => "2.3",
          "USER" => Paypal.api_username,
          "PWD" => Paypal.api_password,
          "SIGNATURE" => Paypal.api_signature,
          "TOKEN" => token
        }
        Paypal::Permissions.normalize_paypal_response(
          Paypal::Permissions.send_request(body)
        )
      end

      def self.send_request(body)
        self.post(Paypal.nvp_uri, :body => body).body
      end

      def self.paypal_permission_name(key)
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
            "token" => token, "cmd" => "_access-permission-login"
          )
          uri.to_s
        end
      end

      def self.normalize_paypal_response(raw_response)
        raw_response_hash = Rack::Utils.parse_nested_query(raw_response)
        if raw_response_hash["ACK"] == "Success"
          normalized_response = {
            :payer_id => raw_response_hash["PAYERID"],
            :first_name => raw_response_hash["FIRSTNAME"],
            :last_name => raw_response_hash["LASTNAME"],
            :email => raw_response_hash["EMAIL"],
            :permissions => normalize_permissions(raw_response_hash)
          }
        end
      end

      def self.normalize_permissions(raw_response_hash)
        normalized_permissions = {}
        permission_name_key = "L_ACCESSPERMISSIONNAME"
        permission_status_key = "L_ACCESSPERMISSIONSTATUS"
        i = 0
        begin
          permission = raw_response_hash[permission_name_key + i.to_s]
          permission_status = raw_response_hash[permission_status_key + i.to_s]
          normalized_permissions[underscore(permission).to_sym] = (permission_status == "Accepted") if permission && permission_status
          i += 1
        end until permission.nil? || permission_status.nil?
        normalized_permissions
      end

      def self.camelize(lower_case_and_underscored_word)
        lower_case_and_underscored_word.to_s.gsub(/(?:^|_)(.)/) { $1.upcase }
      end

      def self.underscore(camel_cased_word)
        word = camel_cased_word.to_s.dup
        word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end
    end
end

