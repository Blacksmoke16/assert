require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::LessThan)]
# Validates a property is less than *value*.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::LessThan(value: 100)]
#   property int32 : Int32 = 95
#
#   @[Assert::LessThan(value: 0.0001_f64)]
#   property float : Float64 = 0.000001
#
#   @[Assert::LessThan(value: "X")]
#   property string : String = "F"
#
#   @[Assert::LessThan(value: Time.utc(2019, 6, 1))]
#   property start_date : Time? = Time.utc(2019, 5, 29)
#
#   @[Assert::LessThan(value: start_date)]
#   property end_date : Time?
#
#   @[Assert::LessThan(value: max_value)]
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
# NOTE: `PropertyType` can be anything that defines a `#<` method.
class Assert::Assertions::LessThan(PropertyType) < Assert::Assertions::Assertion
  initializer(
    actual: PropertyType,
    value: PropertyType
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' should be less than '{{value}}'"
  end

  # :inherit:
  def valid? : Bool
    (value = @value) && (actual = @actual) ? actual < value : true
  end
end
