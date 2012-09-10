require "rubygems"

begin
  require "rmagick"
rescue LoadError => e
  puts "RMagick required to run the generator, gem install rmagick"
  return
end

module Kamcaptcha
  class Generator
    DEFAULTS = {
      :chars  => "23456789ABCDEFGHJKLMNPQRSTUVXYZ".split(""),
      :width  => 240,
      :height => 50,
      :length => 5,
      :format => "png"
    }

    def self.generate(path, options = {})
      options = DEFAULTS.merge(options)

      word  = generate_word(options[:chars], options[:length])
      image = build_image(word, options[:width], options[:height])

      name  = word.delete(" ").downcase
      file  = File.join(path, Kamcaptcha.encrypt(name) + ".#{options[:format]}")

      image.write(file)
      image.destroy!

      file
    end

    def self.generate_word(chars, size)
      (1..size).map { chars[rand(chars.size)] }.join(" ")
    end

    def self.build_image(word, width, height)
      text_img  = Magick::Image.new(width, height)
      black_img = Magick::Image.new(width, height) do
        self.background_color = "black"
      end

      text_img.annotate(Magick::Draw.new, 0, 0, 0, 0, word) do
        self.gravity      = Magick::WestGravity
        self.font_family  = "Verdana"
        self.font_weight  = Magick::BoldWeight
        self.fill         = "#666666"
        self.stroke       = "black"
        self.stroke_width = 2
        self.pointsize    = 44
      end

      # Apply a little blur and fuzzing
      text_img        = text_img.gaussian_blur(1.2, 1.2)
      text_img        = text_img.sketch(20, 30.0, 30.0)
      text_img        = text_img.wave(3, 90)

      # Now we need to get the white out
      text_mask       = text_img.negate
      text_mask.matte = false

      # Add cut-out our captcha from the black image with varying tranparency
      black_img.composite!(text_mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)

      text_img.destroy!
      text_mask.destroy!

      black_img
    end
  end
end
