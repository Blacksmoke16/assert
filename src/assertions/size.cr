require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::Size)]
# Validates a property's size is within a given `Range`.
#
# ### Optional Arguments
# * *exact_message* - Message to display if *range*'s begin and end are the same and *actual* is not that value.
# * *min_message* - Message to display if *actual* is too small.
# * *max_message* - Message to display if *actual* is too big.
# * *normalizer* - Execute a `Proc` to alter *actual* before checking its validity.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::Size(Range(Float64, Float64), range: 2.0..3.0)]
#   property fav_numbers : Array(Int32) = [1, 2, 3]
#
#   @[Assert::Size(Range(Float64, Float64), range: 5.0..10.0, min_message: "Password should be at least 5 characters", max_message: "Password cannot be more than 10 characters")]
#   property password : String = "monkey12"
#
#   @[Assert::Size(Range(Int32, Int32), range: 5..5, exact_message: "Value must be exactly 5 characters")]
#   property exact_value : String = "hello"
#
#   @[Assert::Size(Range(Float64, Float64), range: 5.0..10.0, normalizer: ->(actual : String) { actual.strip })]
#   property normalizer : String = "   crystal   "
# end
#
# Example.new.valid? # => true
# ```
# NOTE: `PropertyType` can be anything that implements `#size`.
# NOTE: The generic `RangeType` represents the type of *range*.
class Assert::Assertions::Size(PropertyType, RangeType) < Assert::Assertions::Assertion
  initializer(
    "@actual": PropertyType,
    "@range": RangeType,
    "@normalizer": "Proc(PropertyType, PropertyType)? = nil",
    "@exact_message": "String? = nil",
    "@min_message": "String? = nil",
    "@max_message": "String? = nil"
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' is not the correct size"
  end

  # :inherit:
  # ameba:disable Metrics/CyclomaticComplexity
  def valid? : Bool
    return true unless (actual = (normalizer = @normalizer) ? normalizer.call @actual : @actual)
    return true if @range.includes? actual.size
    @message_template = if @range.end == @range.begin && !@range.includes? actual.size
                          @exact_message || "'{{property_name}}' is not the proper size.  It should have exactly #{@range.end} #{actual.is_a?(String) ? "character(s)" : "element(s)"}"
                        elsif @range.excludes_end? ? actual.size >= @range.end : actual.size > @range.end
                          @max_message || "'{{property_name}}' is too long.  It should have #{@range.end} #{actual.is_a?(String) ? "character(s)" : "element(s)"} or less"
                        else
                          @min_message || "'{{property_name}}' is too short.  It should have #{@range.begin} #{actual.is_a?(String) ? "character(s)" : "element(s)"} or more"
                        end
    false
  end
end
