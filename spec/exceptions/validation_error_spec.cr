require "../spec_helper"

describe Assert::Exceptions::ValidationError do
  describe "#new" do
    describe Array do
      it "accepts an array of assertions" do
        Assert::Exceptions::ValidationError.new([] of Assert::Assertions::Assertion).message.should eq "Validation tests failed"
      end
    end

    describe Assert::Assertions::Assertion do
      it "accepts a single assertion" do
        Assert::Exceptions::ValidationError.new(Assert::Assertions::NotBlank(String?).new("name", "")).message.should eq "Validation tests failed"
      end
    end
  end

  describe "#to_json" do
    it "returns a JSON object representing the errors" do
      error = Assert::Exceptions::ValidationError.new([
        Assert::Assertions::NotBlank(String?).new("name", ""),
        Assert::Assertions::GreaterThanOrEqual(Int32).new("age", -1, 0),
      ])

      error.to_json.should eq %({"code":400,"message":"Validation tests failed","errors":["'name' should not be blank","'age' should be greater than or equal to '0'"]})
    end
  end

  describe "#to_pretty_json" do
    it "returns a pretty JSON object representing the errors" do
      error = Assert::Exceptions::ValidationError.new([
        Assert::Assertions::NotBlank(String?).new("name", ""),
        Assert::Assertions::GreaterThanOrEqual(Int32).new("age", -1, 0),
      ])

      error.to_pretty_json.should eq %({\n  \"code\": 400,\n  \"message\": \"Validation tests failed\",\n  \"errors\": [\n    \"'name' should not be blank\",\n    \"'age' should be greater than or equal to '0'\"\n  ]\n})
    end
  end

  describe "#to_s" do
    it "should return a string of the failed assertions" do
      error = Assert::Exceptions::ValidationError.new([
        Assert::Assertions::NotBlank(String?).new("name", ""),
        Assert::Assertions::GreaterThanOrEqual(Int32).new("age", -1, 0),
      ])

      error.to_s.should eq "Validation tests failed: 'name' should not be blank, 'age' should be greater than or equal to '0'"
    end
  end
end
