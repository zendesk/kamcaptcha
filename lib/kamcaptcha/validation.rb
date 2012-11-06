module Kamcaptcha
  module Validation
    def kamcaptcha_validates?
      return false unless defined?(params)
      return false unless params.respond_to?(:key?)
      return false unless params.key?(:kamcaptcha)

      token = instance_exec(&Kamcaptcha::Token.lookup)

      Kamcaptcha::Token.valid?(token, params[:kamcaptcha][:input])
    end
  end
end
