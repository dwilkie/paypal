module Paypal
  module Ipn
    module Masspay
      def payment_status
        params["status_1"] if params
      end

      def payment_unclaimed?
        payment_status == "Unclaimed"
      end

      def txn_id
        params["masspay_txn_id_1"] if params
      end
      alias_method :transaction_id, :txn_id

      private
        def unique_id
          params["unique_id_1"]
        end
    end
  end
end

