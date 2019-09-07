require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::Choice)]
# Validates a property is a valid choice.
#
# ### Optional Arguments
# * *min_matches* - Must select _at least_ *min_matches* to be valid.
# * *min_message* - Message to display if too few choices are selected.
# * *max_matches* - Must select _at most_ *max_matches* to be valid.
# * *max_message* - Message to display if too many choices are selected.
# * *multiple_message* - Message to display if one or more values in *actual* are not in *choices*.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::Choice(choices: ["Active", "Inactive", "Pending"])]
#   property status : String = "Inactive"
#
#   @[Assert::Choice(choices: [2, 4, 6], multiple_message: "One ore more value is invalid")]
#   property fav_numbers : Array(Int32) = [2, 4, 6]
#
#   @[Assert::Choice(choices: ['a', 'b', 'c'], min_matches: 2, min_message: "You must have at least 2 choices")]
#   property fav_letters_min : Array(Char) = ['a', 'c']
#
#   @[Assert::Choice(choices: ['a', 'b', 'c'], max_matches: 2, max_message: "You must have at most 2 choices")]
#   property fav_letters_max : Array(Char) = ['a']
# end
#
# Example.new.valid? # => true
# ```
#
# NOTE: The generic `ChoicesType` represents the type of *choices*.
class Assert::Assertions::Choice(PropertyType, ChoicesType) < Assert::Assertions::Assertion
  initializer(
    actual: PropertyType,
    choices: ChoicesType,
    min_matches: "Int32? = nil",
    max_matches: "Int32? = nil",
    min_message: "String? = nil",
    max_message: "String? = nil",
    multiple_message: "String? = nil"
  )

  # :inherit:
  def default_message_template : String
    "'%{property_name}' is not a valid choice"
  end

  # :inherit:
  def valid? : Bool
    return true unless actual = @actual

    case actual
    when Array
      num_matches = (actual & @choices).size

      if min = @min_matches
        return true unless num_matches < min
        @message_template = @min_message || "'%{property_name}': You must select at least #{@min_matches} choice(s)"
        return false
      end

      if max = @max_matches
        return true unless num_matches > max
        @message_template = @max_message || "'%{property_name}': You must select at most #{@max_matches} choice(s)"
        return false
      end

      if num_matches != @choices.size
        @message_template = @multiple_message || "'%{property_name}': One or more of the given values is invalid"
        return false
      end

      true
    else
      @choices.includes? actual
    end
  end
end
