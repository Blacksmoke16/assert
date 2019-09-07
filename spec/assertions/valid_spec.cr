require "../spec_helper"

class SomeObj
  include Assert

  def initialize(@some_val : Int32); end

  @[Assert::EqualTo(value: 50)]
  property some_val : Int32
end

describe Assert::Valid do
  assert_template(Assert::Assertions::Valid, "'%{property_name}' should be valid")

  describe "#valid?" do
    assert_nil(Assert::Assertions::Valid)

    describe Object do
      describe "with a valid sub object" do
        it "should be valid" do
          Assert::Assertions::Valid(SomeObj).new("prop", SomeObj.new(50)).valid?.should be_true
        end
      end

      describe "with an invalid object" do
        it "should be invalid" do
          Assert::Assertions::Valid(SomeObj).new("prop", SomeObj.new(100)).valid?.should be_false
          Assert::Assertions::Valid(SomeObj).new("prop", SomeObj.new(100)).valid?.should be_false
        end
      end
    end

    describe Array do
      describe "with all valid objects" do
        it "should be valid" do
          Assert::Assertions::Valid(Array(SomeObj)).new("prop", [SomeObj.new(50), SomeObj.new(50), SomeObj.new(50)]).valid?.should be_true
        end
      end

      describe "with at least one invalid object" do
        it "should be invalid" do
          Assert::Assertions::Valid(Array(SomeObj)).new("prop", [SomeObj.new(50), SomeObj.new(99), SomeObj.new(50)]).valid?.should be_false
        end
      end
    end
  end
end
