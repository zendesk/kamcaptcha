module Kamcaptcha
  module Token
    class << self
      attr_accessor :generator, :lookup, :store

      def valid?(validation, input)
        input = Kamcaptcha.encrypt(input.to_s.delete(" ").downcase)
        input = instance_exec(input, &generator) if generator

        input == validation
      end
    end
  end
end

# Default form lookup
Kamcaptcha::Token.lookup = lambda do
  params[:kamcaptcha][:validation]
end
