module Paypal
  module Ipn
    include HTTParty

    LIVE_POSTBACK_URI = "https://www.paypal.com/cgi-bin/webscr"
    SANDBOX_POSTBACK_URI = "https://www.sandbox.paypal.com/cgi-bin/webscr"

    def self.included(base)
      base.extend ClassMethods
    end

    def self.postback_uri
      Paypal.environment == "live" ?
      LIVE_POSTBACK_URI :
      SANDBOX_POSTBACK_URI
    end

    def self.verify(params)
      request_uri = URI.parse(postback_uri)
      request_uri.scheme = "https" # force https
      self.post(
        request_uri.to_s,
        :body => params.merge("cmd"=>"_notify-validate")
      ).body == "VERIFIED"
    end

    def payment_status
      params["payment_status"] if params
    end

    def payment_completed?
      payment_status == "Completed"
    end

    def txn_id
      params["txn_id"] if params
    end
    alias_method :transaction_id, :txn_id

    private
      def verify
        Paypal::Ipn.verify(params)
      end

      def receiver_email
        params["receiver_email"]
      end

    module ClassMethods
      private
        def txn_type(params)
          params["txn_type"]
        end

        def masspay_transaction?(params)
          txn_type(params) == "masspay"
        end
    end
  end
end

