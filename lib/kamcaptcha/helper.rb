require 'erb'

module Kamcaptcha
  module Helper
    DEFAULT_LABEL = "Please type the characters in the image below"

    # Usage: <%= kamcaptcha :label => "Please prove that you're a human" %>
    def kamcaptcha(options = {})
      label = options.fetch(:label, DEFAULT_LABEL)
      template = options.fetch(:template, Kamcaptcha.template)

      image = Kamcaptcha.random

      token = image.split(".").first
      token = instance_exec(token, &Kamcaptcha::Token.generator) if Kamcaptcha::Token.generator

      image = File.join('/', Kamcaptcha.prefix, image)

      instance_exec(token, &Kamcaptcha::Token.store) if Kamcaptcha::Token.store

      # Makes sure the ERB template only gets these variables: label, token, image
      form = ERB.new(template).result(OpenStruct.new(:label => label, :token => token, :image => image).send(:binding))

      form = form.html_safe if form.respond_to?(:html_safe)
      form
    end

  end
end
