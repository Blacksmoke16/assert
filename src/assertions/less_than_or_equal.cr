require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::LessThanOrEqual)]
# Validates a property is less than or equal to *value*.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::LessThanOrEqual(value: 100)]
#   property int32_property : Int32 = 100
#
#   @[Assert::LessThanOrEqual(value: 0.0001_f64)]
#   property float_property : Float64 = 0.000001
#
#   @[Assert::LessThanOrEqual(value: "X")]
#   property string_property : String = "X"
#
#   @[Assert::LessThanOrEqual(value: Time.utc(2019, 6, 1))]
#   property start_date : Time? = Time.utc(2019, 5, 29)
#
#   @[Assert::LessThanOrEqual(value: start_date)]
#   property end_date : Time?
#
#   @[Assert::LessThanOrEqual(value: max_value)]
#   property getter_property : UInt8 = 250_u8
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
# NOTE: The type of *value* and the property must match.
# NOTE: `PropertyType` can be anything that defines a `#<=` method.
class Assert::Assertions::LessThanOrEqual(PropertyType) < Assert::Assertions::Assertion
  initializer(
    actual: PropertyType,
    value: PropertyType
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' should be less than or equal to '{{value}}'"
  end

  # :inherit:
  def valid? : Bool
    (value = @value) && (actual = @actual) ? actual <= value : true
  end
end
