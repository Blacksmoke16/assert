require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::GreaterThan)]
# Validates a property is greater than *value*.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::GreaterThan(value: 100)]
#   property int32 : Int32 = 101
#
#   @[Assert::GreaterThan(value: 0.0001_f64)]
#   property float : Float64 = 0.0002
#
#   @[Assert::GreaterThan(value: "X")]
#   property string : String = "Y"
#
#   @[Assert::GreaterThan(value: end_date)]
#   property start_date : Time? = Time.utc(2019, 5, 29)
#
#   @[Assert::GreaterThan(value: Time.utc(2019, 1, 1))]
#   property end_date : Time? = Time.utc(2019, 5, 20)
#
#   @[Assert::GreaterThan(value: max_value)]
#   property getter_property : UInt8 = 250_u8
#
#   def max_value : UInt8
#     200_u8
#   end
# end
#
# Example.new.valid? # => true
# ```
#
# NOTE: *value* can be a hard-coded value like `10`, the name of another property, a constant, or the name of a method.
# NOTE: The type of *value* and the property must match.
# NOTE: `P` can be anything that defines a `#>` method.
class Assert::Assertions::GreaterThan(P) < Assert::Assertions::Assertion
  initializer(
    "@actual": P,
    "@value": P
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' should be greater than '{{value}}'"
  end

  # :inherit:
  def valid? : Bool
    (value = @value) && (actual = @actual) ? actual > value : true
  end
end
