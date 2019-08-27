require "../spec_helper"

describe Assert::GreaterThanOrEqual do
  assert_template(Assert::Assertions::GreaterThanOrEqual, "'{{property_name}}' should be greater than or equal to '{{value}}'", value: nil)

  describe "#valid?" do
    assert_nil(Assert::Assertions::GreaterThanOrEqual, value: 10, type_vars: [Int32?])

    describe "with greater than values" do
      describe String do
        it "should be valid" do
          Assert::Assertions::GreaterThanOrEqual(String).new("prop", "Y", "X").valid?.should be_true
        end
      end

      describe Int do
        it "should be valid" do
          Assert::Assertions::GreaterThanOrEqual(Int32).new("prop", 100, 50).valid?.should be_true
        end
      end

      describe Float do
        it "should be valid" do
          Assert::Assertions::GreaterThanOrEqual(Float64).new("prop", 99.5, 99.0).valid?.should be_true
        end
      end

      describe Time do
        it "should be valid" do
          Assert::Assertions::GreaterThanOrEqual(Time).new("prop", Time.utc(2019, 1, 3), Time.utc(2019, 1, 1)).valid?.should be_true
        end
      end
    end

    describe "with equal values" do
      describe String do
        it "should be valid" do
          Assert::Assertions::GreaterThanOrEqual(String).new("prop", "X", "X").valid?.should be_true
        end
      end

      describe Int do
        it "should be valid" do
          Assert::Assertions::GreaterThanOrEqual(Int32).new("prop", 100, 100).valid?.should be_true
        end
      end

      describe Float do
        it "should be valid" do
          Assert::Assertions::GreaterThanOrEqual(Float64).new("prop", 99.5, 99.5).valid?.should be_true
        end
      end

      describe Time do
        it "should be valid" do
          Assert::Assertions::GreaterThanOrEqual(Time).new("prop", Time.utc(2019, 1, 3), Time.utc(2019, 1, 3)).valid?.should be_true
        end
      end
    end

    describe "with less than values" do
      describe String do
        it "should be invalid" do
          Assert::Assertions::GreaterThanOrEqual(String).new("prop", "A", "Y").valid?.should be_false
        end
      end

      describe Int do
        it "should be invalid" do
          Assert::Assertions::GreaterThanOrEqual(Int32).new("prop", 50, 100).valid?.should be_false
        end
      end

      describe Float do
        it "should be invalid" do
          Assert::Assertions::GreaterThanOrEqual(Float64).new("prop", 99.0, 99.5).valid?.should be_false
        end
      end

      describe Time do
        it "should be invalid" do
          Assert::Assertions::GreaterThanOrEqual(Time).new("prop", Time.utc(2019, 1, 1), Time.utc(2019, 1, 3)).valid?.should be_false
        end
      end
    end
  end
end
