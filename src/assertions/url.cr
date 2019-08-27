require "../assertion"

@[Assert::Assertions::Register(annotation: Assert::Url)]
# Validates a string is a properly formatted URL.
#
# ### Optional Arguments
# * *protocols* - The protocols considered to be valid.
# * *relative_protocol* - If the protocol is optional.
# * *normalizer* - Execute a `Proc` to alter *actual* before checking its validity.
#
# ### Example
# ```
# class Example
#   include Assert
#
#   def initialize; end
#
#   @[Assert::Url]
#   property ipv6_url : String = "http://[::1]:80/"
#
#   @[Assert::Url(relative_protocol: true)]
#   property relative_url : String = "//example.fake/blog/"
#
#   @[Assert::Url(protocols: %w(ftp file git))]
#   property file_url : String = "file://127.0.0.1"
#
#   @[Assert::Url(normalizer: ->(actual : String) { actual.strip })]
#   property normalizer : String = "\x09\x09http://www.google.com"
# end
#
# Example.new.valid? # => true
# ```
class Assert::Assertions::Url(P) < Assert::Assertions::Assertion
  initializer(
    "@actual": String?,
    "@protocols": "Array(String) = %w(http https)",
    "@relative_protocol": "Bool = false",
    "@normalizer": "Proc(String, String)? = nil"
  )

  # :inherit:
  def default_message_template : String
    "'{{property_name}}' is not a valid URL"
  end

  # :inherit:
  def valid? : Bool
    return true unless actual = @actual
    pattern = /^#{@relative_protocol ? "(?:(#{@protocols.join('|')}):)?" : "(#{@protocols.join('|')}):"}\/\/(([\.\pL\pN-]+:)?([\.\pL\pN-]+)@)?(([\pL\pN\pS\-\.])+(\.?([\pL\pN]|xn\-\-[\pL\pN-]+)+\.?)|\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}|\[(?:(?:(?:(?:(?:(?:(?:[0-9a-f]{1,4})):){6})(?:(?:(?:(?:(?:[0-9a-f]{1,4})):(?:(?:[0-9a-f]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:::(?:(?:(?:[0-9a-f]{1,4})):){5})(?:(?:(?:(?:(?:[0-9a-f]{1,4})):(?:(?:[0-9a-f]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:[0-9a-f]{1,4})))?::(?:(?:(?:[0-9a-f]{1,4})):){4})(?:(?:(?:(?:(?:[0-9a-f]{1,4})):(?:(?:[0-9a-f]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-f]{1,4})):){0,1}(?:(?:[0-9a-f]{1,4})))?::(?:(?:(?:[0-9a-f]{1,4})):){3})(?:(?:(?:(?:(?:[0-9a-f]{1,4})):(?:(?:[0-9a-f]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-f]{1,4})):){0,2}(?:(?:[0-9a-f]{1,4})))?::(?:(?:(?:[0-9a-f]{1,4})):){2})(?:(?:(?:(?:(?:[0-9a-f]{1,4})):(?:(?:[0-9a-f]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-f]{1,4})):){0,3}(?:(?:[0-9a-f]{1,4})))?::(?:(?:[0-9a-f]{1,4})):)(?:(?:(?:(?:(?:[0-9a-f]{1,4})):(?:(?:[0-9a-f]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-f]{1,4})):){0,4}(?:(?:[0-9a-f]{1,4})))?::)(?:(?:(?:(?:(?:[0-9a-f]{1,4})):(?:(?:[0-9a-f]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-f]{1,4})):){0,5}(?:(?:[0-9a-f]{1,4})))?::)(?:(?:[0-9a-f]{1,4})))|(?:(?:(?:(?:(?:(?:[0-9a-f]{1,4})):){0,6}(?:(?:[0-9a-f]{1,4})))?::))))\])(:[0-9]+)?(?:\/ (?:[\pL\pN\-._\~!$&\'()*+,;=:@]|\%\%[0-9A-Fa-f]{2})* )*(?:\? (?:[\pL\pN\-._\~!$&\'()*+,;=:@\/?]|\%\%[0-9A-Fa-f]{2})* )?(?:\# (?:[\pL\pN\-._\~!$&\'()*+,;=:@\/?]|\%[0-9A-Fa-f]{2})* )?$/ix
    !(((normalizer = @normalizer) ? normalizer.call actual : actual) =~ pattern).nil?
  end
end
