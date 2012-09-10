module Kamcaptcha
  module Validation
    def kamcaptcha_validates?
      return false unless defined?(params)
      return false unless params.respond_to?(:key?)
      return false unless params.key?(:kamcaptcha)

      Kamcaptcha.valid?(params[:kamcaptcha][:input], params[:kamcaptcha][:validation])
    end
  end
end
