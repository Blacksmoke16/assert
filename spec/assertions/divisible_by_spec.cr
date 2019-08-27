require "../spec_helper"

describe Assert::DivisibleBy do
  assert_template(Assert::Assertions::DivisibleBy, "'{{property_name}}' should be a multiple of '{{value}}'", value: 19.0, type_vars: [Float64?])

  describe "#valid?" do
    assert_nil(Assert::Assertions::DivisibleBy, value: 10, type_vars: [Int32?])

    describe "with divisible values" do
      describe Int do
        it "should be valid" do
          Assert::Assertions::DivisibleBy(Int32).new("prop", 150, 25).valid?.should be_true
        end
      end

      describe Float64 do
        it "should be valid" do
          Assert::Assertions::DivisibleBy(Float64?).new("prop", 15.75, 0.25).valid?.should be_true
        end
      end
    end

    describe "with undivisible values" do
      describe Int do
        it "should be invalid" do
          Assert::Assertions::DivisibleBy(Int32).new("prop", 150, 19).valid?.should be_false
        end
      end

      describe Float64 do
        it "should be invalid" do
          Assert::Assertions::DivisibleBy(Float64?).new("prop", 15.75, 0.3).valid?.should be_false
        end
      end
    end
  end
end
