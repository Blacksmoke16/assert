require "../spec_helper"

describe Assert::IsFalse do
  assert_template(Assert::Assertions::IsFalse, "'{{property_name}}' should be false")

  describe "#valid?" do
    assert_nil(Assert::Assertions::IsFalse, [Bool?])

    describe "with true" do
      it "should be invalid" do
        Assert::Assertions::IsFalse(Bool).new("prop", true).valid?.should be_false
      end
    end

    describe "with false" do
      it "should be valid" do
        Assert::Assertions::IsFalse(Bool?).new("prop", false).valid?.should be_true
      end
    end
  end
end
