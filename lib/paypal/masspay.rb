module Paypal
  module Masspay
    include HTTParty

    def self.masspay(payer_email, receiver_email, amount, currency, note, unique_id)
      request_uri = URI.parse(Paypal.nvp_uri)
      request_uri.scheme = "https" # force https

      body = {
        "METHOD" => "MassPay",
        "VERSION" => "2.3",
        "CURRENCYCODE" => currency,
        "SUBJECT" => payer_email,
        "USER" => Paypal.api_username,
        "PWD" => Paypal.api_password,
        "SIGNATURE" => Paypal.api_signature,
        "RECEIVERTYPE" => "EmailAddress",
        "L_EMAIL0" => receiver_email,
        "L_AMT0" => amount,
        "L_UNIQUEID0" => unique_id,
        "L_NOTE0" => note
      }
      self.post(request_uri.to_s, :body => body).body
    end

    def successful_payment?
      payment_response["ACK"] == "Success"
    end

    private
      def masspay(payer_email, receiver_email, amount, currency, note, unique_id)
        Paypal::Masspay.masspay(
          payer_email,
          receiver_email,
          amount,
          currency,
          note,
          unique_id
        )
      end

      def payment_error_type
        case payment_response["L_ERRORCODE0"]
          when "10002" || "10007"
            :unauthorized
          when "10321"
            :insufficient_funds
          else
            :unknown
        end
      end

      def payment_error_message
        payment_response["L_LONGMESSAGE0"]
      end
  end
end

