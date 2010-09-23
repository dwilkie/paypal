module Paypal
  module Ipn
    module Item
      def item_name(index = nil)
        item_attribute_value("item_name", index)
      end

      def item_quantity(index = nil)
        item_attribute_value("quantity", index).to_i
      end

      def item_number(index = nil)
        item_attribute_value("item_number", index).to_s
      end

      def number_of_cart_items
        num_cart_items = params["num_cart_items"] || 1
        num_cart_items.to_i
      end

      private
        def item_attribute_value(key, index = nil)
          non_indexed_value = params[key]
          index && params["num_cart_items"] ?
            params["#{key}#{index + 1}"]
          : non_indexed_value
        end
    end
  end
end

