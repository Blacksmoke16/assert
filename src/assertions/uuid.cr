require "../assertion"
require "uuid"

@[Assert::Assertions::Register(annotation: Assert::Uuid)]
# Validates a string is a properly formatted [RFC4122 UUID](https://tools.ietf.org/html/rfc4122); either in hyphenated, hexstring, or urn formats.
#
# ### Optional Arguments
# * *versions* - Only allow specific UUID versions.
# * *variants* - Only allow specific UUID variants.
# * *strict* - Only allow the hyphenated UUID format.
# * *normalizer* - Execute a `Proc` to alter *actual* before checking its validity.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::Uuid(strict: false)]
#   property hyphenless : String = "216fff4098d911e3a5e20800200c9a66"
#
#   @[Assert::Uuid(strict: false)]
#   property urn : String = "urn:uuid:3f9eaf9e-cdb0-45cc-8ecb-0e5b2bfb0c20"
#
#   @[Assert::Uuid]
#   property strict : String = "216fff40-98d9-11e3-a5e2-0800200c9a66"
#
#   @[Assert::Uuid(versions: [UUID::Version::V1])]
#   property v1_only : String = "216fff40-98d9-11e3-a5e2-0800200c9a66"
#
#   @[Assert::Uuid(variants: [UUID::Variant::Future, UUID::Variant::NCS])]
#   property other_variants : String = "216fff40-98d9-11e3-e5e2-0800200c9a66"
#
#   @[Assert::Uuid(normalizer: ->(actual : String) { actual.strip })]
#   property normalizer : String = "    216fff40-98d9-11e3-a5e2-0800200c9a66    "
# end
#
# Example.new.valid? # => true
# ```
class Assert::Assertions::Uuid(PropertyType) < Assert::Assertions::Assertion
  # The indxes where a strict `UUID` should have a hyphen.
  HYPHEN_INDEXES = {8, 13, 18, 23}

  initializer(
    "@actual": String?,
    "@versions": "Array(UUID::Version) = [UUID::Version::V1, UUID::Version::V2, UUID::Version::V3, UUID::Version::V4, UUID::Version::V5]",
    "@variants": "Array(UUID::Variant) = [UUID::Variant::RFC4122]",
    "@strict": "Bool = true",
    "@normalizer": "Proc(String, String)? = nil"
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' is not a valid UUID"
  end

  # :inherit:
  def valid? : Bool
    return true unless actual = @actual
    actual = ((normalizer = @normalizer) ? normalizer.call actual : actual)
    return false if @strict && !HYPHEN_INDEXES.all? { |idx| actual.char_at(idx) == '-' }
    uuid : UUID = UUID.new actual
    @variants.any? { |v| v == uuid.variant } && @versions.any? { |v| v == uuid.version }
  rescue e : ArgumentError
    false
  end
end
