require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::IsFalse)]
# Validates a property is `false`.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::IsFalse]
#   property bool : Bool = false
#
#   @[Assert::IsFalse]
#   property nilable_bool : Bool? = nil
# end
#
# Example.new.valid? # => true
# ```
class Assert::Assertions::IsFalse(PropertyType) < Assert::Assertions::Assertion
  initializer(
    actual: Bool?
  )

  # :inherit:
  def default_message_template : String
    "'%{property_name}' should be false"
  end

  # :inherit:
  def valid? : Bool
    return true if @actual.nil?
    @actual == false
  end
end
