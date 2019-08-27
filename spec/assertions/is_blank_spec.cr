require "../spec_helper"

describe Assert::IsBlank do
  assert_template(Assert::Assertions::IsBlank, "'{{property_name}}' should be blank")

  describe "#valid?" do
    assert_nil(Assert::Assertions::IsBlank)

    describe "with a non blank value" do
      it "should be invalid" do
        Assert::Assertions::IsBlank(String?).new("prop", "Jim").valid?.should be_false
      end
    end

    describe "with a blank value" do
      it "should be valid" do
        Assert::Assertions::IsBlank(String?).new("prop", "").valid?.should be_true
      end
    end

    describe :normalizer do
      it "should alter the value before checking its validity" do
        Assert::Assertions::IsBlank(String?).new("prop", "  m", normalizer: ->(actual : String) { actual.chomp('m') }).valid?.should be_true
      end
    end
  end
end
