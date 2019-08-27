require "../spec_helper"

describe Assert::Choice do
  assert_template(Assert::Assertions::Choice, "'{{property_name}}' is not a valid choice", choices: ["one", "two"], type_vars: [String?, Array(String)])

  describe "#valid?" do
    assert_nil(Assert::Assertions::Choice, choices: ["one", "two"], type_vars: [String?, Array(String)])

    describe "non array value" do
      describe "that is a valid choice" do
        it "should be valid" do
          Assert::Assertions::Choice(String?, Array(String)).new("prop", "Inactive", ["Inactive", "Active", "Pending"]).valid?.should be_true
        end
      end

      describe "that is not a valid choice" do
        it "should be invalid" do
          Assert::Assertions::Choice(String?, Array(String)).new("prop", "Expired", ["Inactive", "Active", "Pending"]).valid?.should be_false
        end
      end
    end

    describe Array do
      describe "that is a valid choice" do
        it "should be valid" do
          Assert::Assertions::Choice(Array(Int32), Array(Int32)).new("prop", [2, 3, 4], [2, 3, 4]).valid?.should be_true
        end
      end

      describe :multiple_message do
        describe "without a custom message" do
          it "should use the default" do
            assertion = Assert::Assertions::Choice(Array(Int32), Array(Int32)).new("prop", [2], [2, 3, 4])
            assertion.valid?.should be_false
            assertion.message.should eq "'prop': One or more of the given values is invalid"
          end
        end

        describe "with a custom message" do
          it "should usse that message" do
            assertion = Assert::Assertions::Choice(Array(Int32), Array(Int32)).new("prop", [2], [2, 3, 4], multiple_message: "Invalid Choices")
            assertion.valid?.should be_false
            assertion.message.should eq "Invalid Choices"
          end
        end
      end

      describe :min_matches do
        describe "that has at least that many matches" do
          it "should be valid" do
            Assert::Assertions::Choice(Array(Int32), Array(Int32)).new("prop", [2, 3], [2, 3, 4], min_matches: 2).valid?.should be_true
          end
        end

        describe "that has more matches" do
          it "should be valid" do
            Assert::Assertions::Choice(Array(Int32), Array(Int32)).new("prop", [2, 3, 4, 5], [2, 3, 4, 5, 6], min_matches: 2).valid?.should be_true
          end
        end

        describe "that has less matches" do
          describe "without a custom message" do
            it "should use the default" do
              assertion = Assert::Assertions::Choice(Array(Int32), Array(Int32)).new("prop", [2], [2, 3, 4], min_matches: 2)
              assertion.valid?.should be_false
              assertion.message.should eq "'prop': You must select at least 2 choice(s)"
            end
          end

          describe "with a custom message" do
            it "should usse that message" do
              assertion = Assert::Assertions::Choice(Array(Int32), Array(Int32)).new("prop", [2], [2, 3, 4], min_matches: 2, min_message: "Too few choices")
              assertion.valid?.should be_false
              assertion.message.should eq "Too few choices"
            end
          end
        end
      end

      describe :max_matches do
        describe "that has at least that many matches" do
          it "should be valid" do
            Assert::Assertions::Choice(Array(Int32), Array(Int32)).new("prop", [2, 3], [2, 3, 4], max_matches: 2).valid?.should be_true
          end
        end

        describe "that has less matches" do
          it "should be valid" do
            Assert::Assertions::Choice(Array(Int32), Array(Int32)).new("prop", [2], [2, 3, 4, 5, 6], max_matches: 2).valid?.should be_true
          end
        end

        describe "that has more matches" do
          describe "without a custom message" do
            it "should use the default" do
              assertion = Assert::Assertions::Choice(Array(Int32), Array(Int32)).new("prop", [2, 3, 4], [2, 3, 4, 5], max_matches: 2)
              assertion.valid?.should be_false
              assertion.message.should eq "'prop': You must select at most 2 choice(s)"
            end
          end

          describe "with a custom message" do
            it "should usse that message" do
              assertion = Assert::Assertions::Choice(Array(Int32), Array(Int32)).new("prop", [2, 3, 4], [2, 3, 4, 5], max_matches: 2, max_message: "Too many choices")
              assertion.valid?.should be_false
              assertion.message.should eq "Too many choices"
            end
          end
        end
      end
    end
  end
end
