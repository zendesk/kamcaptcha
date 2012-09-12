require File.expand_path("test/test_helper")

describe Kamcaptcha::Validation do
  def params
    @params
  end

  include Kamcaptcha::Validation

  describe "#kamcaptcha_validates?" do
    describe "when @params.nil?" do
      before { @params = nil }
      it "returns false" do
        refute kamcaptcha_validates?
      end
    end

    describe "when @params.empty?" do
      before { @params = {} }
      it "returns false" do
        refute kamcaptcha_validates?
      end
    end

    describe "when a correct word was entered" do
      before do
        word    = "hello"
        encoded = Kamcaptcha.encrypt(word)
        @params = { :kamcaptcha => { :input => word, :validation => encoded }}
      end

      it "returns true" do
        assert kamcaptcha_validates?
      end
    end

    describe "when a wrong word was entered" do
      before do
        word    = "hello"
        encoded = Kamcaptcha.encrypt(word)
        @params = { :kamcaptcha => { :input => "other", :validation => encoded }}
      end

      it "returns false" do
        refute kamcaptcha_validates?
      end
    end
  end
end
