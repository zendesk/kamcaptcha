describe Kamcaptcha::Generator do

  describe Kamcaptcha::Generator::RandomWordGenerator do
    subject { Kamcaptcha::Generator::RandomWordGenerator.new("3-10") }

    it "delivers words of the specified size range" do
      20.times do
        word = subject.generate.delete(" ")

        assert word.size >= 3, "Size mismatch #{word}"
        assert word.size <= 10, "Size mismatch #{word}"

        assert_match /[0-9A-Z]+/, word
      end
    end
  end

  describe Kamcaptcha::Generator::DictionaryWordGenerator do
    before do
      Kamcaptcha::Generator::DictionaryWordGenerator.dict = [ "foo", "fum" ]
    end

    after do
      Kamcaptcha::Generator::DictionaryWordGenerator.dict = nil
    end

    subject { Kamcaptcha::Generator::DictionaryWordGenerator.new("1-5") }

    it "delivers words from the dict" do
      20.times do
        word = subject.generate.delete(" ")
        assert [ "FOO", "FUM" ].member?(word), "Word #{word} not found"
      end
    end
  end

  describe "#generate" do
    it "generates a file" do
      file = Kamcaptcha::Generator.generate("/tmp").first
      assert File.exist?(file)
      File.unlink(file)
    end
  end
end
