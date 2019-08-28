require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::Email)]
# Validates a property is a properly formatted email.
#
# ### Optional Arguments
# * *mode* - Which validation pattern to use.  See `EmailValidationMode`.
# * *normalizer* - Execute a `Proc` to alter *actual* before checking its validity.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::Email]
#   property loose_email : String = "example@-example.com"
#
#   @[Assert::Email(mode: :html5)]
#   property strict_email : String = "example@example.co.uk"
#
#   @[Assert::Email(mode: :html5, normalizer: ->(actual : String) { actual.strip })]
#   property strict_email_normalizer : String = "  example@example.co.uk  "
# end
#
# Example.new.valid? # => true
# ```
class Assert::Assertions::Email(PropertyType) < Assert::Assertions::Assertion
  initializer(
    actual: String?,
    mode: "EmailValidationMode = EmailValidationMode::Loose",
    normalizer: "Proc(String, String)? = nil"
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' is not a valid email address"
  end

  # :inherit:
  def valid? : Bool
    return true unless actual = @actual
    !(((normalizer = @normalizer) ? normalizer.call actual : actual) =~ @mode.get_pattern).nil?
  end

  # Which validation pattern to use to validate the email.
  enum EmailValidationMode
    # A simple regular expression. Allows all values with an `@` symbol in, and a `.` in the second host part of the email address.
    Loose

    # This matches the pattern used for the [HTML5 email input element](https://www.w3.org/TR/html5/sec-forms.html#email-state-typeemail).
    HTML5

    # TODO: Validate against [RFC 5322](https://tools.ietf.org/html/rfc5322).
    Strict

    # Returns the `Regex` pattern for `self`.
    def get_pattern : Regex
      case self
      when .loose? then /^.+\@\S+\.\S+$/
      when .html5? then /^[a-zA-Z0-9.!\#$\%&\'*+\\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$/
      else
        raise NotImplementedError.new "Unsupported pattern: #{self}"
      end
    end
  end
end
