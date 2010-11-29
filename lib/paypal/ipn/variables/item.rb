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

      def item_amount(index = nil)
        item_attribute_value("mc_gross", index, "_")
      end

      def number_of_cart_items
        num_cart_items = params["num_cart_items"] || 1
        num_cart_items.to_i
      end

      private
        def item_attribute_value(key, index = nil, delimeter = "")
          non_indexed_value = params[key]
          index && params["num_cart_items"] ?
            params["#{key}#{delimeter}#{index + 1}"]
          : non_indexed_value
        end
    end
  end
end

