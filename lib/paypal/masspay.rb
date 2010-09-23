module Paypal
  module Masspay
    include HTTParty

    def self.masspay(payer_email, receiver_email, amount, currency, note, unique_id)
      request_uri = Paypal.nvp_uri
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
        "L_EMAIL0" => receiver.email,
        "L_AMT0" => amount,
        "L_UNIQUEID0" => unique_id,
        "L_NOTE0" => note
      }
      self.post(request_uri.to_s, :body => body).body
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
  end
end

