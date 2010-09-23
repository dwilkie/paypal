module Paypal
  module Ipn
    module Masspay
      def payment_status
        params["status_1"]
      end

      def txn_id
        params["masspay_txn_id_1"]
      end
      alias_method :transaction_id, :txn_id

      private
        def unique_id
          params["unique_id_1"]
        end
    end
  end
end

