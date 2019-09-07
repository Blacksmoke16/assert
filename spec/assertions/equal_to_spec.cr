require "../spec_helper"

describe Assert::EqualTo do
  assert_template(Assert::Assertions::EqualTo, "'%{property_name}' should be equal to '%{value}'", value: nil)

  describe "#valid?" do
    describe "with equal values" do
      describe Bool do
        it "should be valid" do
          Assert::Assertions::EqualTo(Bool).new("prop", true, true).valid?.should be_true
        end
      end

      describe Array do
        it "should be valid" do
          Assert::Assertions::EqualTo(Array(Int32)).new("prop", [1, 2], [1, 2]).valid?.should be_true
        end
      end

      describe Time do
        it "should be valid" do
          Assert::Assertions::EqualTo(Time).new("prop", Time.utc(2019, 1, 1), Time.utc(2019, 1, 1)).valid?.should be_true
        end
      end
    end

    describe "with not equal values" do
      describe Bool do
        it "should be invalid" do
          Assert::Assertions::EqualTo(Bool).new("prop", true, false).valid?.should be_false
        end
      end

      describe Array do
        it "should be invalid" do
          Assert::Assertions::EqualTo(Array(Int32)).new("prop", [1, 2], [1]).valid?.should be_false
        end
      end

      describe Time do
        it "should be invalid" do
          Assert::Assertions::EqualTo(Time).new("prop", Time.utc(2019, 1, 1), Time.utc(2019, 1, 2)).valid?.should be_false
        end
      end
    end
  end
end
