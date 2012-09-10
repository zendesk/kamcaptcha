describe Kamcaptcha::Helper do
  include Kamcaptcha::Helper

  describe "#kamcaptcha" do
    subject { Kamcaptcha.stub(:random, "hello.png") { kamcaptcha } }

    describe "when given a label" do
      subject { Kamcaptcha.stub(:random, "hello.png") { kamcaptcha(:label => "KAMCAPTCHA!") } }

      it "uses that label" do
        assert_match /KAMCAPTCHA!/, subject
      end
    end

    it "uses a default label" do
      assert_match /#{Kamcaptcha::Helper::DEFAULT_LABEL}/, subject
    end
  end
end
