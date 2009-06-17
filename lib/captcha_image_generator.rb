begin
  require 'RMagick' 
rescue Exception => e
  puts "Warning: RMagick not installed, you cannot generate captcha images on this machine"
end

require 'captcha_util'

module CaptchaImageGenerator

  @@eligible_chars     = (2..9).to_a + %w(A B C D E F G H J K L M N P Q R S T U V X Y Z)
  @@default_parameters = {
    :image_width    => 240,
    :image_height   => 50,
    :captcha_length => 5,
    :file_format => 'png'
  }

  def self.generate_captcha_image(params = {})

    params.reverse_merge!(@@default_parameters)

    file_format = ['png', 'gif'].include?(params[:file_format]) ? ".#{params[:file_format]}" : '.png'
    
    text_img  = Magick::Image.new(params[:image_width].to_i, params[:image_height].to_i)
    black_img = Magick::Image.new(params[:image_width].to_i, params[:image_height].to_i) do
      self.background_color = 'black'
    end

    # Generate a 5 character random string
    random_string = (1..params[:captcha_length].to_i).collect { @@eligible_chars[rand(@@eligible_chars.size)] }.join(' ')

    # Gerenate the filename based on the string where we have removed the spaces
    filename = CaptchaUtil::encrypt_string(random_string.gsub(' ', '').downcase) + file_format

    # Render the text in the image
    text_img.annotate(Magick::Draw.new, 0,0,0,0, random_string) {
      self.gravity = Magick::WestGravity
      self.font_family = 'Thonburi'
      self.font_weight = Magick::BoldWeight
      self.fill = '#666666'
      self.stroke = 'black'
      self.stroke_width = 2
      self.pointsize = 44
    }

    # Apply a little blur and fuzzing
    text_img = text_img.gaussian_blur(1.2, 1.2)
    text_img = text_img.sketch(20, 30.0, 30.0)
    text_img = text_img.wave(3, 90)

    # Now we need to get the white out
    text_mask = text_img.negate
    text_mask.matte = false

    # Add cut-out our captcha from the black image with varying tranparency
    black_img.composite!(text_mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)

    # Write the file to disk
    puts 'Writing image file ' + filename
    black_img.write(filename) # { self.depth = 8 }

    # Collect rmagick
    GC.start
  end

end  