require "digest"

require 'kamcaptcha/token'

# You must configure Kamcaptcha with a path to the generated words, and a salt.
# The salt must be the same you used when generating words.
module Kamcaptcha
  class << self
    attr_accessor :salt, :path, :template
    attr_writer :prefix

    def prefix
      @prefix || ""
    end

    def random
      images[rand(images.size)]
    end

    def images
      @images ||= Dir.glob("#{path}/*.*").map { |f| File.basename(f) }
    end

    def encrypt(string)
      raise "You must configure a salt" if Kamcaptcha.salt.nil?
      Digest::SHA2.hexdigest("#{salt}::#{string}")
    end
  end
end

Kamcaptcha.template = <<-END
  <div class="kamcaptcha">
    <label for="kamcaptcha_input"><%= label %></label><input type="text" id="kamcaptcha_input" name="kamcaptcha[input]" />
    <input type="hidden" name="kamcaptcha[validation]" value="<%= token %>" />
    <img src="<%= image %>" />
  </div>
END
