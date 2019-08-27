require "./spec_helper"

@[Assert::Assertions::Register(annotation: Assert::Tesst)]
# Test assertion to test common assertion behavior
class TestAssertion(PropertyType) < Assert::Assertions::Assertion
  @some_key = "FOO"
  @some_bool = false

  def initialize(property_name : String, message : String? = nil, groups : Array(String)? = nil)
    super property_name, message, groups
  end

  # :inherit:
  def default_message_template : String
    "DEFAULT_MESSAGE"
  end

  # :inherit:
  def valid? : Bool
    true
  end
end

describe Assert::Assertions::Assertion do
  describe ".new" do
    describe "#groups" do
      it "groups should be empty by default" do
        TestAssertion(Nil).new("prop").groups.should be_empty
      end

      it "should use provided groups if they were provided" do
        TestAssertion(Nil).new("prop", groups: ["one", "two"]).groups.should_not be_empty
      end
    end

    describe "#message" do
      it "should replace placeholders with their value" do
        TestAssertion(Nil).new("prop", message: "{{some_key}} is {{some_bool}}").message.should eq "FOO is false"
      end
    end

    describe "#message_template" do
      it "returns the default template if no message is provided" do
        TestAssertion(Nil).new("prop").message.should eq "DEFAULT_MESSAGE"
      end

      it "should use provided message template if one was supplied" do
        TestAssertion(Nil).new("prop", message: "CUSTOM_MESSAGE").message.should eq "CUSTOM_MESSAGE"
      end
    end

    describe "#property_name" do
      it "should return the property_name" do
        TestAssertion(Nil).new("prop").property_name.should eq "prop"
      end
    end
  end
end
