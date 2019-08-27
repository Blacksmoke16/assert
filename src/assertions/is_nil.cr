require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::IsNil)]
# Validates a property is `nil`.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::IsNil]
#   property nilable_int : Int32? = nil
#
#   @[Assert::IsNil]
#   property nilable_string : String? = nil
# end
#
# Example.new.valid? # => true
# ```
class Assert::Assertions::IsNil(P) < Assert::Assertions::Assertion
  initializer(
    "@actual": P
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' should be null"
  end

  # :inherit:
  def valid? : Bool
    @actual.nil?
  end
end
