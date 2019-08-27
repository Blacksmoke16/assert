require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::NotEqualTo)]
# Validates a property is not equal to *value*.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::NotEqualTo(value: 100)]
#   property int32 : Int32 = 50
#
#   @[Assert::NotEqualTo(value: 0.0001)]
#   property float : Float64 = 0.00001
#
#   @[Assert::NotEqualTo(value: "X")]
#   property string : String = "Y"
#
#   @[Assert::NotEqualTo(value: max_value)]
#   property getter_property : UInt8 = 255_u8
#
#   def max_value : UInt8
#     250_u8
#   end
# end
#
# Example.new.valid? # => true
# ```
#
# NOTE: *value* can be a hard-coded value like `10`, the name of another property, a constant, or the name of a method.
# NOTE: The type of *value* and *actual* must match.
# NOTE: `PropertyType` can be anything that defines a `#!=` method.
class Assert::Assertions::NotEqualTo(PropertyType) < Assert::Assertions::Assertion
  initializer(
    "@actual": PropertyType,
    "@value": PropertyType
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' should not be equal to '{{value}}'"
  end

  # :inherit:
  def valid? : Bool
    @actual != @value
  end
end
