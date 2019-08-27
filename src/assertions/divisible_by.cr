require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::DivisibleBy)]
# Validates a property is divisible by *value*.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::DivisibleBy(value: 0.5)]
#   property float : Float64 = 100.0
#
#   @[Assert::DivisibleBy(value: 2)]
#   property int : Int32 = 1234
#
#   @[Assert::DivisibleBy(value: get_value)]
#   property getter_property : UInt16 = 256_u16
#
#   def get_value : UInt16
#     16_u16
#   end
# end
#
# Example.new.valid? # => true
# ```
#
# NOTE: *value* can be a hard-coded value like `10`, the name of another property, a constant, or the name of a method.
# NOTE: The type of *value* and the property must match.
class Assert::Assertions::DivisibleBy(PropertyType) < Assert::Assertions::Assertion
  initializer(
    "@actual": PropertyType,
    "@value": PropertyType
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' should be a multiple of '{{value}}'"
  end

  # :inherit:
  def valid? : Bool
    return true unless (actual = @actual) && (value = @value)
    (actual % value).zero?
  end
end
