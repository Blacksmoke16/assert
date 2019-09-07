require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::RegexMatch)]
# Validates a property matches a `Regex` pattern.
#
# ### Optional Arguments
# * *match* - Whether the string should have to match the pattern to be valid.
# * *normalizer* - Execute a `Proc` to alter *actual* before checking its validity.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::RegexMatch(pattern: /foo==bar/)]
#   property match : String? = "foo==bar"
#
#   @[Assert::RegexMatch(pattern: /foo==bar/, match: false)]
#   property not_match : String = "foo--bar"
#
#   @[Assert::RegexMatch(pattern: /^foo/, normalizer: ->(actual : String) { actual.strip })]
#   property normalizer : String = " foo"
# end
#
# Example.new.valid? # => true
# ```
class Assert::Assertions::RegexMatch(PropertyType) < Assert::Assertions::Assertion
  initializer(
    actual: String?,
    pattern: Regex,
    match: "Bool = true",
    normalizer: "Proc(String, String)? = nil"
  )

  # :inherit:
  def default_message_template : String
    "'%{property_name}' is not valid"
  end

  # :inherit:
  def valid? : Bool
    return true unless actual = @actual
    matched : Int32? = (((normalizer = @normalizer) ? normalizer.call actual : actual) =~ @pattern)
    @match ? !matched.nil? : matched.nil?
  end
end
