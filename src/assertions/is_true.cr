require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::IsTrue)]
# Validates a property is `true`.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::IsTrue]
#   property bool : Bool = true
#
#   @[Assert::IsTrue]
#   property nilable_bool : Bool? = nil
# end
#
# Example.new.valid? # => true
# ```
class Assert::Assertions::IsTrue(PropertyType) < Assert::Assertions::Assertion
  initializer(
    "@actual": Bool?
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' should be true"
  end

  # :inherit:
  def valid? : Bool
    return true if @actual.nil?
    @actual == true
  end
end
