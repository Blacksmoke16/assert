require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::InRange)]
# Validates a property is within a given `Range`.
#
# ### Optional Arguments
# * *not_in_range_message* - Message to display if *actual* is not included in *range*.
# * *min_message* - Message to display if *range* only has a minimum and *actual* is too small.
# * *max_message* - Message to display if *range* only has a maximum and *actual* is too big.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::InRange(Range(Float64, Nil), range: 0.0..)]
#   property minimum_only : Int32 = 27
#
#   @[Assert::InRange(Range(Nil, Int64), range: ..100_000_000_000)]
#   property maximum_only : Int32 = 50_000
#
#   @[Assert::InRange(Range(Float64, Float64), range: 0.0..1000.0)]
#   property range : Float64 = 3.14
#
#   @[Assert::InRange(Range(Int32, Int32), range: 0..10, not_in_range_message: "That is not a valid {{property_name}}")]
#   property fav_number : UInt8 = 8_u8
#
#   @[Assert::InRange(Range(UInt8, UInt8), range: 0_u8..50_u8, min_message: "Number of cores must be positive", max_message: "There must be less than 50 cores")]
#   property cores : Int32 = 32
# end
#
# Example.new.valid? # => true
# ```
# NOTE: The generic `RangeType` represents the type of *range*.
class Assert::Assertions::InRange(PropertyType, RangeType) < Assert::Assertions::Assertion
  initializer(
    "@actual": PropertyType,
    "@range": RangeType,
    "@not_in_range_message": "String? = nil",
    "@min_message": "String? = nil",
    "@max_message": "String? = nil"
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' is out of range"
  end

  # :inherit:
  # ameba:disable Metrics/CyclomaticComplexity
  def valid? : Bool
    return true unless actual = @actual
    return true if @range.includes? actual

    lower_bound = @range.begin
    upper_bound = @range.end

    @message_template = if lower_bound && upper_bound
                          @not_in_range_message || "'{{property_name}}' should be between #{lower_bound} and #{@range.excludes_end? ? upper_bound - 1 : upper_bound}"
                        elsif upper_bound && (@range.excludes_end? ? actual >= upper_bound : actual > upper_bound)
                          @max_message || "'{{property_name}}' should be #{@range.excludes_end? ? upper_bound - 1 : upper_bound} or less"
                        else
                          @min_message || "'{{property_name}}' should be #{lower_bound} or more"
                        end
    false
  end
end
