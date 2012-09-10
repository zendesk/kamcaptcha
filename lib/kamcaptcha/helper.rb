module Kamcaptcha
  module Helper
    DEFAULT_LABEL = "Please type the characters in the image below"

    # Usage: <%= kamcaptcha :label => "Please prove that you're a human" %>
    def kamcaptcha(options = {})
      label = options.fetch(:label, DEFAULT_LABEL)
      image = Kamcaptcha.random
      token = image.split(".").first

      <<-FORM
        <div class="kamcaptcha">
          <label for="kamcaptcha[input]">#{label}</label><input type="text" id="kamcaptcha[input]" name="kamcaptcha[input]" />
          <input type="hidden" name="kamcaptcha[validation]" value="#{token}" />
          <img src="#{image}" />
        </div
      FORM
    end

  end
end
