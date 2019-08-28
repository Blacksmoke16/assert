require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::Ip)]
# Validates a property is a properly formatted IP address.
#
# ### Optional Arguments
# * *version* - Which IP version to use.  See `IPVersion`.
# * *normalizer* - Execute a `Proc` to alter *actual* before checking its validity.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::Ip]
#   property ipv4 : String = "255.255.255.255"
#
#   @[Assert::Ip(version: :ipv6)]
#   property ipv6 : String = "0::0"
#
#   @[Assert::Ip(normalizer: ->(actual : String) { actual.strip })]
#   property normalizer : String = "  192.168.1.1  "
# end
#
# Example.new.valid? # => true
# ```
class Assert::Assertions::Ip(PropertyType) < Assert::Assertions::Assertion
  initializer(
    actual: String?,
    version: "IPVersion = IPVersion::IPV4",
    normalizer: "Proc(String, String)? = nil"
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' is not a valid IP address"
  end

  # :inherit:
  def valid? : Bool
    return true unless actual = @actual
    !(((normalizer = @normalizer) ? normalizer.call actual : actual) =~ @version.get_pattern).nil?
  end

  # Which IP version to use to validate against.
  enum IPVersion
    # Matches IPv4 format.
    IPV4

    # Matches IPv6 format.
    IPV6

    # Returns the `Regex` pattern for `self`.
    def get_pattern : Regex
      case self
      when .ipv4? then /^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
      when .ipv6? then /^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$/
      else
        raise NotImplementedError.new "Unsupported version: #{self}"
      end
    end
  end
end
