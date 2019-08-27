require "../spec_helper"

describe Assert::IsNil do
  assert_template(Assert::Assertions::IsNil, "'{{property_name}}' should be null")

  describe "#valid?" do
    assert_nil(Assert::Assertions::IsNil)

    describe "with a non nil value" do
      it "should be invalid" do
        Assert::Assertions::IsNil(Bool?).new("prop", false).valid?.should be_false
      end
    end
  end
end
