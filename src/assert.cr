require "./assertion"
require "./assertions/*"
require "./exceptions/*"

# Annotation based object validation library.
#
# See the `Assert::Assertions` namespace for the full assertion list as well as each assertion class for more detailed information/examples.
#
# See `Assert::Assertions::Assertion` for common/high level assertion usage documentation.
#
# ### Example Usage
#
# `Assert` supports both object based validations via annotations as well as ad hoc value validations via class methods.
# #### Object Validation
#
# ```
# require "assert"
#
# class User
#   include Assert
#
#   def initialize(@name : String, @age : Int32?, @email : String, @password : String); end
#
#   # Assert their name is not blank
#   @[Assert::NotBlank]
#   property name : String
#
#   # Asserts that their age is >= 0 AND not nil
#   @[Assert::NotNil]
#   @[Assert::GreaterThanOrEqual(value: 0)]
#   property age : Int32?
#
#   # Assert their email is not blank AND is a valid format
#   @[Assert::Email(message: "'%{actual}' is not a proper email")]
#   @[Assert::NotBlank]
#   property email : String
#
#   # Assert their password is between 7 and 25 characters
#   @[Assert::Size(Range(Int32, Int32), range: 7..25)]
#   property password : String
# end
#
# user = User.new "Jim", 19, "test@email.com", "monkey123"
#
# # #valid? returns `true` if `self` is valid, otherwise `false`
# user.valid? # => true
#
# user.email = "foobar"
# user.password = "hi"
#
# # #valid? returns `true` if `self` is valid, otherwise `false`
# user.valid? # => false
#
# # #validate returns an array of assertions that were not valid
# user.validate.empty? # => false
#
# begin
#   # #validate! raises an exception if `self` is not valid
#   user.validate!
# rescue ex : Assert::Exceptions::ValidationError
#   ex.to_s    # => Validation tests failed:  'foobar' is not a proper email, 'password' is too short.  It should have 7 character(s) or more
#   ex.to_json # => {"code":400,"message":"Validation tests failed","errors":["'foobar' is not a proper email","'password' is too short.  It should have 7 character(s) or more"]}
# end
# ```
#
# #### Ad Hoc Validation
# ```
# # Each assertion automatically defines a shortcut class method for ad hoc validations.
# Assert.not_blank "foo" # => true
# Assert.not_blank ""    # => false
#
# begin
#   # The bang version will raise if the value is invalid.
#   Assert.not_blank! "   "
# rescue ex
#   ex.to_s # => Validation tests failed: 'actual' should not be blank
# end
#
# begin
#   # Optional arguments can be used just like the annotation versions.
#   Assert.equal_to! 15, 20, message: "%{actual} does not equal %{value}"
# rescue ex
#   ex.to_s # => Validation tests failed: 15 does not equal 20
# end
# ```
module Assert
  # Define the Assertion annotations.
  macro finished
    {% verbatim do %}
      {% begin %}
        {% for assertion in Assert::Assertions::Assertion.subclasses %}
          {% ann = assertion.annotation(Assert::Assertions::Register) %}
          {% raise "#{assertion.name} must apply the `Assert::Assertions::Register` annotation." unless ann %}
          # :nodoc:
          annotation {{ann[:annotation].id}}; end

          {% initializer = assertion.methods.find &.name.==("initialize") %}
          {% method_name = ann[:annotation].stringify.split("::").last.underscore.id %}
          {% method_args = initializer.args[1..-1] %}
          {% method_vars = initializer.args[1..-1].map(&.name).splat %}
          {% free_variables = assertion.type_vars %}
          {% generic_args = free_variables.size > 1 ? ",#{free_variables[1..-1].splat}".id : "".id %}

          # `{{assertion.stringify.gsub(/\(.*\)/, "").id}}` assertion shortcut method.
          #
          # Can be used for ad hoc validations when applying annotations is not possible.
          def self.{{method_name}}({{method_args.splat}}) : Bool forall {{free_variables.splat}}
            assertion = {{assertion.name.gsub(/\(.*\)/, "").id}}({{method_args.first.restriction}}{{generic_args}}).new(\{{@def.args.first.name.stringify}}, {{method_vars}})
            assertion.valid?
          end

          # `{{assertion.stringify.gsub(/\(.*\)/, "").id}}` assertion shortcut method.
          #
          # Can be used for ad hoc validations when applying annotations is not possible.
          # Raises an `Assert::Exceptions::ValidationError` if the value is not valid.
          def self.{{method_name}}!({{method_args.splat}}) : Bool forall {{free_variables.splat}}
            assertion = {{assertion.name.gsub(/\(.*\)/, "").id}}({{method_args.first.restriction}}{{generic_args}}).new(\{{@def.args.first.name.stringify}}, {{method_vars}})
            assertion.valid? || raise Assert::Exceptions::ValidationError.new assertion
          end
        {% end %}
      {% end %}
    {% end %}
  end

  # Returns `true` if `self` is valid, otherwise `false`.
  # Optionally only run assertions a part of the provided *groups*.
  def valid?(*groups : String) : Bool
    valid? groups.to_a
  end

  # :ditto:
  def valid?(groups : Array(String) = Array(String).new) : Bool
    validate(groups).empty?
  end

  # Runs the assertions on `self`, returning the assertions that are not valid.
  # Optionally only run assertions a part of the provided *groups*.
  def validate(*groups : String) : Array(Assert::Assertions::Assertion)
    validate groups.to_a
  end

  # :ditto:
  def validate(groups : Array(String) = Array(String).new) : Array(Assert::Assertions::Assertion)
    {% begin %}
      {% assertions = [] of String %}
      {% for ivar in @type.instance_vars %}
        # TODO: Remove once https://github.com/crystal-lang/crystal/issues/8093 is resolved
        {% for assertion in Assert::Assertions::Assertion.subclasses.select(&.name.stringify.includes?("(P")) %}
          {% if (ann_class = assertion.annotation(Assert::Assertions::Register)) && ann_class[:annotation] != nil && (ann = ivar.annotation(ann_class[:annotation].resolve)) %}
            {% raise "#{@type}'s #{ann_class} assertion must not set 'property_name'." if ann["property_name"] %}
            {% raise "#{@type}'s #{ann_class} assertion must not set 'actual'." if ann["actual"] %}
            {% assertions << %(#{assertion.name.gsub(/\(.*\)/, "")}(#{ivar.type}#{ann.args.empty? ? "".id : ",#{ann.args.splat}".id}).new(property_name: #{ivar.name.stringify}, actual: #{ivar.id}, #{ann.named_args.double_splat})).id %}
          {% end %}
        {% end %}
      {% end %}
      assertions = {{assertions}} of Assert::Assertions::Assertion

      assertions.reject! { |a| (a.groups & groups).empty? } unless groups.empty?

      assertions.reject &.valid?
    {% end %}
  end

  # Runs the assertions on `self`, raises an `Assert::Exceptions::ValidationError` if `self` is not valid.
  #
  # Optionally only run assertions a part of the provided *groups*.
  def validate!(*groups : String) : Nil
    validate! groups.to_a
  end

  # :ditto:
  def validate!(groups : Array(String) = Array(String).new) : Nil
    failed_assertions = validate groups
    raise Assert::Exceptions::ValidationError.new failed_assertions unless failed_assertions.empty?
  end
end
