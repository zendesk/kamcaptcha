require "digest"

# You must configure Kamcaptcha with a path to the generated words, and a salt.
# The salt must be the same you used when generating words.
module Kamcaptcha
  class << self
    attr_accessor :salt, :path
    attr_writer :template, :prefix

    def prefix
      @prefix || ""
    end

    def template
      @template || <<-FORM
        <div class="kamcaptcha">
          <label for="kamcaptcha_input">%s</label><input type="text" id="kamcaptcha_input" name="kamcaptcha[input]" />
          <input type="hidden" name="kamcaptcha[validation]" value="%s" />
          <img src="%s" />
        </div>
      FORM
    end
  end

  def self.random
    images[rand(images.size)]
  end

  def self.images
    @images ||= Dir.glob("#{path}/*.*").map { |f| File.basename(f) }
  end

  def self.valid?(input, validation)
    input = input.to_s.delete(" ").downcase
    encrypt(input) == validation
  end

  def self.encrypt(string)
    raise "You must configure a salt" if Kamcaptcha.salt.nil?
    Digest::SHA2.hexdigest("#{salt}::#{string}")
  end
end
