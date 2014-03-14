module Paypal
  module Ipn
    module Masspay
      def payment_status(i)
        params["status_#{i}"] if params
      end

      def payment_unclaimed?
        payment_status == "Unclaimed"
      end

      def txn_id(i)
        params["masspay_txn_id_#{i}"] if params
      end
      alias_method :transaction_id, :txn_id

      private
        def unique_id(i)
          params["unique_id_#{i}"]
        end
    end
  end
end

