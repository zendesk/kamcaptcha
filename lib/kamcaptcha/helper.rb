module Kamcaptcha
  module Helper
    DEFAULT_LABEL = "Please type the characters in the image below"

    # Usage: <%= kamcaptcha :label => "Please prove that you're a human" %>
    def kamcaptcha(options = {})
      label = options.fetch(:label, DEFAULT_LABEL)
      path_prefix = options.fetch(:prefix, Kamcaptcha.prefix)
      template = options.fetch(:template, Kamcaptcha.template)

      image = Kamcaptcha.random
      token = image.split(".").first
      image = File.join('/', path_prefix, image)

      form = template % [label, token, image]
      form = form.html_safe if form.respond_to?(:html_safe)
      form
    end
  end
end
