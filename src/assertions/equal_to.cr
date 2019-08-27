require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::EqualTo)]
# Validates a property is equal to *value*.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::EqualTo(value: 100)]
#   property int32 : Int32 = 100
#
#   @[Assert::EqualTo(value: 0.0001)]
#   property float : Float64 = 0.0001
#
#   @[Assert::EqualTo(value: "X")]
#   property string : String = "X"
#
#   @[Assert::EqualTo(value: max_value)]
#   property getter_property : UInt8 = 255_u8
#
#   def max_value : UInt8
#     255_u8
#   end
# end
#
# Example.new.valid? # => true
# ```
#
# NOTE: *value* can be a hard-coded value like `10`, the name of another property, a constant, or the name of a method.
# NOTE: The type of *value* and *actual* must match.
# NOTE: `PropertyType` can be anything that defines a `#==` method.
class Assert::Assertions::EqualTo(PropertyType) < Assert::Assertions::Assertion
  initializer(
    "@actual": PropertyType,
    "@value": PropertyType
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' should be equal to '{{value}}'"
  end

  # :inherit:
  def valid? : Bool
    @actual == @value
  end
end
