require "../spec_helper"

describe Assert::NotNil do
  assert_template(Assert::Assertions::NotNil, "'%{property_name}' should not be null")

  describe "#valid?" do
    assert_nil(Assert::Assertions::NotNil, valid: false)

    describe "with a non nil value" do
      it "should be valid" do
        Assert::Assertions::NotNil(Bool?).new("prop", false).valid?.should be_true
      end
    end
  end
end
