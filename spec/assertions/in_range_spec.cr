require "../spec_helper"

describe Assert::InRange do
  assert_template(Assert::Assertions::InRange, "'{{property_name}}' is out of range", range: 0.0..10.0, type_vars: [Float64?, Range(Float64, Float64)])

  describe "#valid?" do
    assert_nil(Assert::Assertions::InRange, [Float64?, Range(Float64, Float64)], range: 0.0..10.0)

    describe :not_in_range_message do
      describe "too small" do
        it "should be invalid" do
          assertion = Assert::Assertions::InRange(Float64?, Range(Float64, Float64)).new("prop", 2.0, range: 5.0..10.0)
          assertion.valid?.should be_false
          assertion.message.should eq "'prop' should be between 5.0 and 10.0"
        end
      end

      describe "too big" do
        it "should be invalid" do
          assertion = Assert::Assertions::InRange(Float64?, Range(Float64, Float64)).new("prop", 11.0, range: 5.0..10.0)
          assertion.valid?.should be_false
          assertion.message.should eq "'prop' should be between 5.0 and 10.0"
        end
      end

      describe "equal" do
        it "should be valid" do
          Assert::Assertions::InRange(Float64?, Range(Float64, Float64)).new("prop", 10.0, range: 5.0..10.0).valid?.should be_true
        end
      end

      describe "too big excluding end" do
        it "should be invalid" do
          assertion = Assert::Assertions::InRange(Float64?, Range(Float64, Float64)).new("prop", 10.0, range: 5.0...10.0)
          assertion.valid?.should be_false
          assertion.message.should eq "'prop' should be between 5.0 and 9.0"
        end
      end

      describe "with a custom message" do
        it "should be invalid" do
          assertion = Assert::Assertions::InRange(Float64?, Range(Float64, Float64)).new("prop", 2.0, range: 5.0..10.0, not_in_range_message: "NOT VALID")
          assertion.valid?.should be_false
          assertion.message.should eq "NOT VALID"
        end
      end
    end

    describe :min_message do
      describe "too small" do
        it "should be invalid" do
          assertion = Assert::Assertions::InRange(Int32?, Range(Int32, Nil)).new("prop", 2, range: 5..)
          assertion.valid?.should be_false
          assertion.message.should eq "'prop' should be 5 or more"
        end
      end

      describe "equal" do
        it "should be valid" do
          Assert::Assertions::InRange(Float64?, Range(Float64, Nil)).new("prop", 5.0, range: 5.0..).valid?.should be_true
        end
      end

      describe "with a custom message" do
        it "should be invalid" do
          assertion = Assert::Assertions::InRange(Float64?, Range(Float64, Nil)).new("prop", 2.0, range: 5.0.., min_message: "NOT VALID")
          assertion.valid?.should be_false
          assertion.message.should eq "NOT VALID"
        end
      end
    end

    describe :max_message do
      describe "too big" do
        it "should be invalid" do
          assertion = Assert::Assertions::InRange(Float64?, Range(Nil, Float64)).new("prop", 101.0, range: ..100.0)
          assertion.valid?.should be_false
          assertion.message.should eq "'prop' should be 100.0 or less"
        end
      end

      describe "equal" do
        it "should be valid" do
          Assert::Assertions::InRange(Float64?, Range(Nil, Float64)).new("prop", 100.0, range: ..100.0).valid?.should be_true
        end
      end

      describe "equal excluding end" do
        it "should be valid" do
          assertion = Assert::Assertions::InRange(Float64?, Range(Nil, Float64)).new("prop", 100.0, range: ...100.0)
          assertion.valid?.should be_false
          assertion.message.should eq "'prop' should be 99.0 or less"
        end
      end

      describe "with a custom message" do
        it "should be invalid" do
          assertion = Assert::Assertions::InRange(Float64?, Range(Nil, Float64)).new("prop", 101.0, range: ..100.0, max_message: "NOT VALID")
          assertion.valid?.should be_false
          assertion.message.should eq "NOT VALID"
        end
      end
    end
  end
end
