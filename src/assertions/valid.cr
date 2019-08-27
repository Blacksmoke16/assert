require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::Valid)]
# Validates child object(s) are valid; rendering the parent object invalid if any assertions on the child object(s) fail.
#
# ### Example
# ```
# class Foo
#   include Assert
#
#   def initialize(@some_val : Int32); end
#
#   @[Assert::EqualTo(value: 50)]
#   property some_val : Int32
# end
#
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::EqualTo(value: 100)]
#   property int32 : Int32 = 100
#
#   @[Assert::Valid]
#   property foo : Foo = Foo.new(50)
#
#   @[Assert::Valid]
#   property foos : Array(Foo) = [Foo.new(50), Foo.new(50)]
# end
#
# Example.new.valid? # => true
# ```
class Assert::Assertions::Valid(P) < Assert::Assertions::Assertion
  initializer(
    "@actual": P
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' should be valid"
  end

  # :inherit:
  def valid? : Bool
    return true unless actual = @actual
    case actual
    when Array  then actual.all?(&.valid?)
    when Assert then actual.valid?
    else
      true
    end
  end
end
