require "../spec_helper"

describe Assert::GreaterThan do
  assert_template(Assert::Assertions::GreaterThan, "'%{property_name}' should be greater than '%{value}'", value: nil)

  describe "#valid?" do
    assert_nil(Assert::Assertions::GreaterThan, value: 10, type_vars: [Int32?])

    describe "with greater than values" do
      describe String do
        it "should be valid" do
          Assert::Assertions::GreaterThan(String).new("prop", "Y", "X").valid?.should be_true
        end
      end

      describe Int do
        it "should be valid" do
          Assert::Assertions::GreaterThan(Int32).new("prop", 100, 50).valid?.should be_true
        end
      end

      describe Float do
        it "should be valid" do
          Assert::Assertions::GreaterThan(Float64).new("prop", 99.5, 99.0).valid?.should be_true
        end
      end

      describe Time do
        it "should be valid" do
          Assert::Assertions::GreaterThan(Time).new("prop", Time.utc(2019, 1, 3), Time.utc(2019, 1, 1)).valid?.should be_true
        end
      end
    end

    describe "with equal values" do
      describe String do
        it "should be invalid" do
          Assert::Assertions::GreaterThan(String).new("prop", "X", "X").valid?.should be_false
        end
      end

      describe Int do
        it "should be invalid" do
          Assert::Assertions::GreaterThan(Int32).new("prop", 100, 100).valid?.should be_false
        end
      end

      describe Float do
        it "should be invalid" do
          Assert::Assertions::GreaterThan(Float64).new("prop", 99.5, 99.5).valid?.should be_false
        end
      end

      describe Time do
        it "should be invalid" do
          Assert::Assertions::GreaterThan(Time).new("prop", Time.utc(2019, 1, 3), Time.utc(2019, 1, 3)).valid?.should be_false
        end
      end
    end

    describe "with less than values" do
      describe String do
        it "should be invalid" do
          Assert::Assertions::GreaterThan(String).new("prop", "A", "Y").valid?.should be_false
        end
      end

      describe Int do
        it "should be invalid" do
          Assert::Assertions::GreaterThan(Int32).new("prop", 50, 100).valid?.should be_false
        end
      end

      describe Float do
        it "should be invalid" do
          Assert::Assertions::GreaterThan(Float64).new("prop", 99.0, 99.5).valid?.should be_false
        end
      end

      describe Time do
        it "should be invalid" do
          Assert::Assertions::GreaterThan(Time).new("prop", Time.utc(2019, 1, 1), Time.utc(2019, 1, 3)).valid?.should be_false
        end
      end
    end
  end
end
