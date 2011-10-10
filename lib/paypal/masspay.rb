module Paypal
  module Masspay
    include HTTParty

    def self.masspay(payer_email, receiver_email, amount, currency, note, unique_id, email_subject = nil)
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
        "RECEIVERTYPE" => "EmailAddress"
      }
      body.merge!("EMAILSUBJECT" => email_subject) if email_subject
      response = ''
      Rails.logger.info(receiver_email)
      if receiver_email.is_a?(Array)
        max = 250
        new_body = body.dup
        Rails.logger.info(new_body)
        (receiver_email.length.to_f / max).ceil.times do |group|
          offset = group * max
          receiver_email[offset..(offset + max -1)].each_with_index do |email, i|
            new_body = new_body.merge({
              "L_EMAIL#{i}" => email,
              "L_AMT#{i}" => amount.is_a?(Array) ? amount[i] : amount,
              "L_UNIQUEID#{i}" => "#{unique_id}-#{i}",
              "L_NOTE#{i}" => note})
          end
          Rails.logger.info(new_body)
          response = self.post(request_uri.to_s, :body => new_body).body
        end
      else
        body = body.merge({
          "L_EMAIL0" => receiver_email,
          "L_AMT0" => amount,
          "L_UNIQUEID0" => unique_id,
          "L_NOTE0" => note})
        response = self.post(request_uri.to_s, :body => body).body
      end
      response
    end

    def successful_payment?
      payment_response["ACK"] == "Success"
    end

    private
      def masspay(payer_email, receiver_email, amount, currency, note, unique_id, email_subject = '')
        Paypal::Masspay.masspay(
          payer_email,
          receiver_email,
          amount,
          currency,
          note,
          unique_id,
          email_subject
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

