begin
  require "RMagick"
rescue LoadError => e
  puts "RMagick required to run the generator, gem install rmagick"
  exit
end

module Kamcaptcha
  class Generator
    class WordGenerator
      attr_reader :min, :max

      def initialize(length)
        if length.to_s =~ /^(\d+)$/
          @min = @max = $1.to_i
        elsif length =~ /^(\d+)-(\d+)$/
          @min = [$1.to_i, $2.to_i].min
          @max = [$1.to_i, $2.to_i].max
        else
          raise ArgumentError.new("Invalid word length specified: #{length}")
        end
      end
    end

    class RandomWordGenerator < WordGenerator
      CHARS = "23456789ABCDEFGHJKLMNPQRSTUVXYZ".split("")

      def generate
        length  = min
        length += Kernel.rand(max - min) unless max == min

        (1..length).map { CHARS[rand(CHARS.size)] }.join(" ")
      end
    end

    class DictionaryWordGenerator < WordGenerator
      class << self
        attr_accessor :dict # Use this to set a custom dictionary or dictionary generating function
      end

      def generate
        words[rand(words.size)].split("").join(" ")
      end

      def words
        @words ||= begin
          if self.class.dict
            if self.class.dict.respond_to?(:call)
              w = self.class.dict.call
            else
              w = self.class.dict
            end
          else
            w = default_dict
          end

          w.map!    { |w| w.upcase }
          w.select! { |w| w.size >= min && w.size <= max && w !~ /O/ }
          w
        end
      end

      def default_dict
        return File.read("/usr/share/dict/words").split("\n") if File.exists?("/usr/share/dict/words")
        return File.read("/usr/dict/words").split("\n") if File.exists?("/usr/dict/words")

        raise ArgumentError.new("Sorry, need a dictionary file")
      end
    end

    DEFAULTS = {
      :width  => 240,
      :height => 50,
      :length => 5,
      :format => "png",
      :count  => 1
    }

    def self.generate(path, options = {})
      options = DEFAULTS.merge(options)

      if options[:source] != "random"
        source = DictionaryWordGenerator.new(options[:length])
      else
        source = RandomWordGenerator.new(options[:length])
      end

      files = []

      options[:count].times do
        word  = source.generate
        image = build_image(word, options[:width], options[:height])
        name  = word.delete(" ").downcase
        file  = File.join(path, Kamcaptcha.encrypt(name) + ".#{options[:format]}")

        image.write(file)
        image.destroy!

        files << file
      end

      files
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
