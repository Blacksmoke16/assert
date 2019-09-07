require "../spec_helper"

describe Assert::NotBlank do
  assert_template(Assert::Assertions::NotBlank, "'%{property_name}' should not be blank")

  describe "#valid?" do
    assert_nil(Assert::Assertions::NotBlank)

    describe "with a non blank value" do
      it "should be valid" do
        Assert::Assertions::NotBlank(String?).new("prop", "Jim").valid?.should be_true
      end
    end

    describe "with a blank value" do
      it "should be invalid" do
        Assert::Assertions::NotBlank(String?).new("prop", "").valid?.should be_false
      end
    end

    describe :normalizer do
      it "should alter the value before checking its validity" do
        Assert::Assertions::NotBlank(String?).new("prop", "", normalizer: ->(actual : String) { actual + 'f' }).valid?.should be_true
      end
    end
  end
end
