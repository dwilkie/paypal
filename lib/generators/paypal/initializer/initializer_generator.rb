require 'rails/generators'
module Paypal
  class InitializerGenerator < Rails::Generators::Base

    def self.source_root
       @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def copy_conversation_file
      copy_file "paypal.rb", "config/initializers/paypal.rb"
    end
  end
end

