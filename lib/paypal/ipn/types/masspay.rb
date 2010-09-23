module Paypal
  module Ipn
    module Masspay
      def self.included(base)
        base.extend ClassMethods
      end

      private
        def unique_id
          params["unique_id_1"]
        end

      module ClassMethods
        private
          def masspay_txn_id(params)
            params["masspay_txn_id_1"]
          end
      end
    end
  end
end

