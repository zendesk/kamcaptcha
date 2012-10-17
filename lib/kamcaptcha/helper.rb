module Kamcaptcha
  module Helper
    DEFAULT_LABEL = "Please type the characters in the image below"

    # Usage: <%= kamcaptcha :label => "Please prove that you're a human" %>
    def kamcaptcha(options = {})
      label = options.fetch(:label, DEFAULT_LABEL)
      template = options.fetch(:template, Kamcaptcha.template)

      image = Kamcaptcha.random

      token = image.split(".").first
      token = Kamcaptcha::Token.generator.call(token) if Kamcaptcha::Token.generator

      image = File.join('/', Kamcaptcha.prefix, image)

      instance_exec(token, &Kamcaptcha::Token.store) if Kamcaptcha::Token.store

      form = template % { :label => label, :token => token, :image => image }
      form = form.html_safe if form.respond_to?(:html_safe)
      form
    end
  end
end
