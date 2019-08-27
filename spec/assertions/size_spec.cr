require "../spec_helper"

describe Assert::Size do
  assert_template(Assert::Assertions::Size, "'{{property_name}}' is not the correct size", range: 0.0..10.0, type_vars: [String?, Range(Float64, Float64)])

  describe "#valid?" do
    assert_nil(Assert::Assertions::Size, range: 0.0..10.0, type_vars: [String?, Range(Float64, Float64)])

    describe String do
      describe "with a valid range" do
        it "should be valid" do
          Assert::Assertions::Size(String?, Range(Float64, Float64)).new("prop", "hello", range: 0.0..10.0).valid?.should be_true
        end
      end

      describe "with a valid exact range" do
        it "should be valid" do
          Assert::Assertions::Size(String?, Range(Int32, Int32)).new("prop", "hello", range: 5..5).valid?.should be_true
        end
      end

      describe "with an invalid inclusive range" do
        it "should be valid" do
          assertion = Assert::Assertions::Size(String?, Range(Int32, Int32)).new("prop", "hello", range: 5...5)
          assertion.valid?.should be_false
          assertion.message.should eq "'prop' is not the proper size.  It should have exactly 5 character(s)"
        end
      end

      describe "too long" do
        describe "with the default template" do
          it "should be invalid and use the default template" do
            assertion = Assert::Assertions::Size(String, Range(Float64, Float64)).new("prop", "goodbye", range: 1.0..5.0)
            assertion.valid?.should be_false
            assertion.message.should eq "'prop' is too long.  It should have 5.0 character(s) or less"
          end
        end

        describe "with a custom template" do
          it "should be invalid and use the provided template" do
            assertion = Assert::Assertions::Size(String, Range(Float64, Float64)).new("prop", "goodbye", range: 1.0..5.0, max_message: "Too Long")
            assertion.valid?.should be_false
            assertion.message.should eq "Too Long"
          end
        end
      end

      describe "too short" do
        describe "with the default template" do
          it "should be invalid and use the default template" do
            assertion = Assert::Assertions::Size(String, Range(Float64, Float64)).new("prop", "", range: 1.0..5.0)
            assertion.valid?.should be_false
            assertion.message.should eq "'prop' is too short.  It should have 1.0 character(s) or more"
          end
        end

        describe "with a custom template" do
          it "should be invalid and use the provided template" do
            assertion = Assert::Assertions::Size(String, Range(Float64, Float64)).new("prop", "", range: 1.0..5.0, min_message: "Too Short")
            assertion.valid?.should be_false
            assertion.message.should eq "Too Short"
          end
        end
      end

      describe "not exact" do
        describe "with the default template" do
          it "should be invalid and use the default template" do
            assertion = Assert::Assertions::Size(String, Range(Int32, Int32)).new("prop", "foo", range: 5..5)
            assertion.valid?.should be_false
            assertion.message.should eq "'prop' is not the proper size.  It should have exactly 5 character(s)"
          end
        end

        describe "with a custom template" do
          it "should be invalid and use the provided template" do
            assertion = Assert::Assertions::Size(String, Range(Float64, Float64)).new("prop", "foo", range: 5.0..5.0, exact_message: "Not Right")
            assertion.valid?.should be_false
            assertion.message.should eq "Not Right"
          end
        end
      end
    end

    describe Array do
      describe "with a valid range" do
        it "should be valid" do
          Assert::Assertions::Size(Array(Int32), Range(Int64, Int64)).new("prop", [1, 2, 3], range: 1_i64..5_i64).valid?.should be_true
        end
      end

      describe "too long" do
        describe "with the default template" do
          it "should be invalid and use the default template" do
            assertion = Assert::Assertions::Size(Array(Int32), Range(Int32, Int32)).new("prop", [1, 2, 3, 4, 5, 6], range: 1..5)
            assertion.valid?.should be_false
            assertion.message.should eq "'prop' is too long.  It should have 5 element(s) or less"
          end
        end

        describe "with a custom template" do
          it "should be invalid and use the provided template" do
            assertion = Assert::Assertions::Size(Array(Int32), Range(Int32, Int32)).new("prop", [1, 2, 3, 4, 5, 6], range: 1..5, max_message: "Too Long")
            assertion.valid?.should be_false
            assertion.message.should eq "Too Long"
          end
        end
      end

      describe "too short" do
        describe "with the default template" do
          it "should be invalid and use the default template" do
            assertion = Assert::Assertions::Size(Array(Int32), Range(Float64, Float64)).new("prop", [] of Int32, range: 1.0..5.0)
            assertion.valid?.should be_false
            assertion.message.should eq "'prop' is too short.  It should have 1.0 element(s) or more"
          end
        end

        describe "with a custom template" do
          it "should be invalid and use the provided template" do
            assertion = Assert::Assertions::Size(Array(Int32), Range(Float64, Float64)).new("prop", [] of Int32, range: 1.0..5.0, min_message: "Too Short")
            assertion.valid?.should be_false
            assertion.message.should eq "Too Short"
          end
        end
      end

      describe "not exact" do
        describe "with the default template" do
          it "should be invalid and use the default template" do
            assertion = Assert::Assertions::Size(Array(Int32), Range(Float64, Float64)).new("prop", [1, 2, 3] of Int32, range: 5.0..5.0)
            assertion.valid?.should be_false
            assertion.message.should eq "'prop' is not the proper size.  It should have exactly 5.0 element(s)"
          end
        end

        describe "with a custom template" do
          it "should be invalid and use the provided template" do
            assertion = Assert::Assertions::Size(Array(Int32), Range(Float64, Float64)).new("prop", [1, 2, 3] of Int32, range: 5.0..5.0, exact_message: "Not Right")
            assertion.valid?.should be_false
            assertion.message.should eq "Not Right"
          end
        end
      end
    end

    describe :normalizer do
      it "should alter the value before checking its validity" do
        Assert::Assertions::Size(String, Range(Float64, Float64)).new("prop", "  foo  ", range: 1.0..5.0, normalizer: ->(actual : String) { actual.strip }).valid?.should be_true
      end
    end
  end
end
