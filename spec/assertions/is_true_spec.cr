require "../spec_helper"

describe Assert::IsTrue do
  assert_template(Assert::Assertions::IsTrue, "'%{property_name}' should be true")

  describe "#valid?" do
    assert_nil(Assert::Assertions::IsTrue, [Bool?])

    describe "with true" do
      it "should be valid" do
        Assert::Assertions::IsTrue(Bool).new("prop", true).valid?.should be_true
      end
    end

    describe "with false" do
      it "should be invalid" do
        Assert::Assertions::IsTrue(Bool?).new("prop", false).valid?.should be_false
      end
    end
  end
end
