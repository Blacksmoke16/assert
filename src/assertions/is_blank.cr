require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::IsBlank)]
# Validates a property is blank, that is, consists exclusively of unicode whitespace.
#
# ### Optional Arguments
# * *normalizer* - Execute a `Proc` to alter *actual* before checking its validity.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::IsBlank]
#   property string : String = ""
#
#   @[Assert::IsBlank]
#   property multiple_spaces : String = "      "
#
#   @[Assert::IsBlank]
#   property nilble_string : String? = nil
#
#   @[Assert::IsBlank(normalizer: ->(actual : String) { actual.chomp('a') })]
#   property normalizer : String = "    a"
# end
#
# Example.new.valid? # => true
# ```
class Assert::Assertions::IsBlank(PropertyType) < Assert::Assertions::Assertion
  initializer(
    actual: String?,
    normalizer: "Proc(String, String)? = nil"
  )

  # :inherit:
  def default_message_template : String
    "'%{property_name}' should be blank"
  end

  # :inherit:
  def valid? : Bool
    return true unless actual = @actual
    ((normalizer = @normalizer) ? normalizer.call actual : actual).blank?
  end
end
