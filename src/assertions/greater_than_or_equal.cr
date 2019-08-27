require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::GreaterThanOrEqual)]
# Validates a property is greater than or equal to *value*.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::GreaterThanOrEqual(value: 100)]
#   property int32 : Int32 = 100
#
#   @[Assert::GreaterThanOrEqual(value: 0.0001_f64)]
#   property float : Float64 = 0.0002
#
#   @[Assert::GreaterThanOrEqual(value: "X")]
#   property string : String = "Y"
#
#   @[Assert::GreaterThanOrEqual(value: end_date)]
#   property start_date : Time? = Time.utc(2019, 5, 29)
#
#   @[Assert::GreaterThanOrEqual(value: Time.utc(2019, 1, 1))]
#   property end_date : Time? = Time.utc(2019, 5, 20)
#
#   @[Assert::GreaterThanOrEqual(value: max_value)]
#   property getter_property : UInt8 = 250_u8
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
# NOTE: The type of *value* and the property must match.
# NOTE: `PropertyType` can be anything that defines a `#>=` method.
class Assert::Assertions::GreaterThanOrEqual(PropertyType) < Assert::Assertions::Assertion
  initializer(
    "@actual": PropertyType,
    "@value": PropertyType
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' should be greater than or equal to '{{value}}'"
  end

  # :inherit:
  def valid? : Bool
    (value = @value) && (actual = @actual) ? actual >= value : true
  end
end
