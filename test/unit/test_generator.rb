describe Kamcaptcha::Generator do
  describe "#generate_word" do
    it "builds a word by the given chars and length" do
      word = Kamcaptcha::Generator.generate_word([ "a", "b" ], 6)
      assert_equal 6, word.split(" ").size
      assert_match /[ab ]+/, word
    end
  end

  describe "#generate" do
    it "generates a file" do
      file = Kamcaptcha::Generator.generate("/tmp")
      assert File.exist?(file)
      File.unlink(file)
    end
  end
end
