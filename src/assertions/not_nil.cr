require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::NotNil)]
# Validates a property is not `nil`.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::NotNil]
#   property nilable_int : Int32? = 17
#
#   @[Assert::NotNil]
#   property nilable_string : String? = "Bob"
# end
#
# Example.new.valid? # => true
# ```
class Assert::Assertions::NotNil(PropertyType) < Assert::Assertions::Assertion
  initializer(
    actual: PropertyType
  )

  # :inherit:
  def default_message_template : String
    "'%{property_name}' should not be null"
  end

  # :inherit:
  def valid? : Bool
    !@actual.nil?
  end
end
