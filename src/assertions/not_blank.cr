require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::NotBlank)]
# Validates a property is not blank, that is, does not consist exclusively of unicode whitespace.
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
#   @[Assert::NotBlank]
#   property string : String = "foo"
#
#   @[Assert::NotBlank]
#   property single_character : String = "   a   "
#
#   @[Assert::NotBlank]
#   property nilble_string : String? = nil
#
#   @[Assert::NotBlank(normalizer: ->(actual : String) { "Hello #{actual}" })]
#   property normalizer : String = ""
# end
#
# Example.new.valid? # => true
# ```
class Assert::Assertions::NotBlank(PropertyType) < Assert::Assertions::Assertion
  initializer(
    actual: String?,
    normalizer: "Proc(String, String)? = nil"
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' should not be blank"
  end

  # :inherit:
  def valid? : Bool
    return true unless actual = @actual
    !((normalizer = @normalizer) ? normalizer.call actual : actual).blank?
  end
end
