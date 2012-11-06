require File.expand_path("test/test_helper")

describe Kamcaptcha::Token do
  describe "#valid?" do
    let(:validation) { Kamcaptcha.encrypt("hello") }

    it "should handle other types" do
      refute Kamcaptcha::Token.valid?(validation, 123)
    end

    it "should handle spaces" do
      assert Kamcaptcha::Token.valid?(validation, "h e l l   o")
    end

    it "should handle mixed case" do
      assert Kamcaptcha::Token.valid?(validation, "HeLLo")
    end

    describe "with a custom generator" do
      before(:all) { @generator, Kamcaptcha::Token.generator = Kamcaptcha::Token.generator, lambda {|_| "hello"}}
      after(:all) { Kamcaptcha::Token.generator = @generator }

      it "should call the generator" do
        assert Kamcaptcha::Token.valid?("hello", "anything")
      end
    end
  end
end
