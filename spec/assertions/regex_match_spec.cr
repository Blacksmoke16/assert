require "../spec_helper"

describe Assert::RegexMatch do
  assert_template(Assert::Assertions::RegexMatch, "'%{property_name}' is not valid", pattern: /foo/)

  describe "#valid?" do
    assert_nil(Assert::Assertions::RegexMatch, pattern: /foo/)

    describe :mode do
      describe :match do
        describe "with a matching value" do
          it "should be valid" do
            Assert::Assertions::RegexMatch(String?).new("prop", "foo", pattern: /foo/).valid?.should be_true
          end
        end

        describe "with a not matching value" do
          it "should be invalid" do
            Assert::Assertions::RegexMatch(String?).new("prop", "bar", pattern: /foo/).valid?.should be_false
          end
        end
      end

      describe :not_match do
        describe "with a matching value" do
          it "should be invalid" do
            Assert::Assertions::RegexMatch(String?).new("prop", "foo", pattern: /foo/, match: false).valid?.should be_false
          end
        end

        describe "with a not matching value" do
          it "should be valid" do
            Assert::Assertions::RegexMatch(String?).new("prop", "bar", pattern: /foo/, match: false).valid?.should be_true
          end
        end
      end
    end

    describe :normalizer do
      it "should alter the value before checking its validity" do
        Assert::Assertions::RegexMatch(String?).new("prop", " foo", pattern: /^foo/, normalizer: ->(actual : String) { actual.strip }).valid?.should be_true
      end
    end
  end
end
