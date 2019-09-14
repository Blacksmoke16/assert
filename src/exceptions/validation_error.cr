require "json"

# Represents a validation error.  It can be raised manually or via `Assert#validate!`.
class Assert::Exceptions::ValidationError < Exception
  def self.new(failed_assertion : Assert::Assertions::Assertion)
    new [failed_assertion] of Assert::Assertions::Assertion
  end

  def initialize(@failed_assertions : Array(Assert::Assertions::Assertion))
    super "Validation tests failed"
  end

  # Returns a JSON/pretty JSON object for `self`.
  #
  # Can be overwritten to change the JSON schema.
  # ```
  # error = Assert::Exceptions::ValidationError.new([
  #   Assert::Assertions::NotBlank(String?).new("name", ""),
  #   Assert::Assertions::GreaterThanOrEqual(Int32).new("age", -1, 0),
  # ])
  #
  # error.to_pretty_json # =>
  # {
  #   "code":    400,
  #   "message": "Validation tests failed",
  #   "errors":  [
  #     "'name' should not be blank",
  #     "'age' should be greater than or equal to '0'",
  #   ],
  # }
  # ```
  def to_json(builder : JSON::Builder) : Nil
    builder.object do
      builder.field "code", 400
      builder.field "message", @message
      builder.field "errors", @failed_assertions.map(&.message)
    end
  end

  # Returns failed validations as a string.
  #
  # ```
  # error = Assert::Exceptions::ValidationError.new([
  #   Assert::Assertions::NotBlank(String?).new("name", ""),
  #   Assert::Assertions::GreaterThanOrEqual(Int32).new("age", -1, 0),
  # ])
  #
  # error.to_s # => "Validation tests failed: 'name' should not be blank, 'age' should be greater than or equal to '0'"
  # ```
  def to_s : String
    String.build do |str|
      str << "Validation tests failed: "
      @failed_assertions.map(&.message).join(", ", str)
    end
  end
end
