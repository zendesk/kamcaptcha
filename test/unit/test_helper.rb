require File.expand_path("test/test_helper")

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

    it "uses the token" do
      assert_match /value="hello"/, subject
    end

    describe "should use the token storage if it exists" do
      before(:all) { @store, Kamcaptcha::Token.store = Kamcaptcha::Token.store, lambda {|token| @token = token}}
      after(:all) { Kamcaptcha::Token.store = @store }

      it "should set the storage" do
        subject # will store the token

        assert_equal "hello", @token
      end
    end

    describe "html safety" do
      before(:all) do
        class String
          def html_safe
            "safe"
          end
        end
      end

      after(:all) do
        class String
          remove_method :html_safe
        end
      end

      it "should call #html_safe" do
        assert_equal "safe", subject
      end
    end

    describe "image path" do
      before(:all) { @prefix, Kamcaptcha.prefix = Kamcaptcha.prefix, "omg/123" }
      after(:all) { Kamcaptcha.prefix = @prefix }

      subject { Kamcaptcha.stub(:random, "hello.png") { kamcaptcha(:template => "%{image}") } }

      it "should prefix image path" do
        assert_equal "/omg/123/hello.png", subject
      end
    end

    describe "should use custom generator if it exists" do
      before(:all) { @generator, Kamcaptcha::Token.generator = Kamcaptcha::Token.generator, lambda {|_| "token"}}
      after(:all) { Kamcaptcha::Token.generator = @generator }

      subject { Kamcaptcha.stub(:random, "hello.png") { kamcaptcha(:template => "%{token}") } }

      it "should use the custom generator" do
        assert_equal "token", subject
      end
    end

    describe "when given a template" do
      subject { Kamcaptcha.stub(:random, "hello.png") { kamcaptcha(:template => "this-isnt-real") } }

      it "should use custom template" do
        assert_equal "this-isnt-real", subject
      end
    end
  end
end
