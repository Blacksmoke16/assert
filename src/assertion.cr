# See `Assert::Assertions::Assertion` for assertion usage documentation as well as
# `Assert::Assertions` for the full list of assertions.
module Assert::Assertions
  # Contains metadata associated with an `Assertion`.
  #
  # Used to define the assertion's annotation.
  #
  # ```
  # @[Assert::Assertions::Register(annotation: Assert::MyAssertion)]
  # class MyAssertion(PropertyType) < Assert::Assertions::Assertion
  # end
  # ```
  annotation Register; end

  # Base class of all assertions.
  #
  # An assertion consists of:
  # 1. An annotation applied to a property.
  # 2. A class that implements the validation logic for that annotation.
  #
  # Each assertion defines an *actual* ivar that represents the current value
  # of the property.  The type of *actual* is used to determine what types of properties
  # the annotation can be applied to.  I.e. if the type is `String`, that assertion
  # can only be applied to `String` properties.  The generic `P` can also be used, which
  # would allow it to be added to any type of property.
  #
  # All assertions must inherit from `Assertion` as well as apply the `Register` annotation, and give the name of the annotation; `Assert::SomeAssertion` for example.
  #
  # Assertions can define additional ivars within the initializer.  The name of each ivar
  # is also used as the name to use on the annotation.
  #
  # Ivars with a default value are considered optional.  The default value
  # will be used if that value is not specified within the annotation.
  #
  # `Assertion.initializer` can be used as an easier way to define the `initialize` method.
  #
  # ### Custom Assertions
  # Custom assertions can easily be defined by inheriting from `Assertion`, applying the `Register` annotation, and setting the name of the annotation to read.
  #
  # ```
  # @[Assert::Assertions::Register(annotation: Assert::MyCustom)]
  # class MyCustom(PropertyType) < Assert::Assertions::Assertion
  #   def initialize(
  #     @actual : String?,            # This assertion can only be used on `String?` or `String` properties. Is set automatically.
  #     @some_value : Int32,          # A required argument, must be supplied within the annotation or a compile time error will be raised.
  #     property_name : String,       # The property this assertion was applied to.  Is set automatically.
  #     @some_bool : Bool = true,     # An optional argument.  The value will be `true` if *some_bool* is not specified within the annotation.
  #     message : String? = nil,      # Optionally override the message on a per property basis.
  #     groups : Array(String)? = nil # Optionally override the groups on a per property basis.
  #   )
  #     super property_name, message, groups # Be sure to call `super property_name, message, groups` to set the property_name/message/groups.
  #   end
  #
  #   # The initialize method could also have been written using the `Assertion.initializer` macro.
  #   initializer(
  #     "@actual": String?,
  #     "@some_value": Int32,
  #     "@some_bool": "Bool = true"
  #   )
  #
  #   # :inherit:
  #   def default_message_template : String
  #     # The default message template to use if one is not supplied.
  #     # Instance variables on `self` can be used within the template by surrounding the ivar's name in double curly braces, E.x. `{{some_bool}}`.
  #     "'{{property_name}}' is not valid."
  #   end
  #
  #   # :inherit:
  #   def valid? : Bool
  #     # Define validation logic
  #   end
  # end
  # ```
  #
  # NOTE: Every assertion must have a generic `PropertyType` as its first generic type variable; even if the assertion is not using it.
  #
  # This custom assertion is now ready to use.  Be sure to `include Assert`.
  # ```
  # # Since *some_value* does not have a default value, it is required.
  # @[Assert::MyCustom(some_value: 123)]
  # property name : String
  #
  # # Override the default value of *some_bool*.
  # @[Assert::MyCustom(some_value: 456, some_bool: false)]
  # property name : String
  # ```
  #
  # ### Validation Groups
  # By default, `Assert` bases the validity of an object based on _all_ the assertions defined on it.  However, each assertion has an optional
  # `#groups` property that can be used to assign that assertion to a given group(s). Assertions without explicit groups are automatically assigned
  # to the "default" group.  This allows assertions without a group to be ran in conjunction with those in an explicit group.
  # Validation groups can be used to run a subset of assertions, and base the validity of the object on that subset.
  # ```
  # class Groups
  #   include Assert
  #
  #   def initialize(@group_1 : Int32, @group_2 : Int32, @default_group : Int32); end
  #
  #   @[Assert::EqualTo(value: 100, groups: ["group1"])]
  #   property group_1 : Int32
  #
  #   @[Assert::EqualTo(value: 200, groups: ["group2"])]
  #   property group_2 : Int32
  #
  #   @[Assert::EqualTo(value: 300)]
  #   property default_group : Int32
  # end
  #
  # Groups.new(100, 200, 300).valid?                      # => true
  # Groups.new(100, 100, 100).valid?                      # => false
  # Groups.new(100, 100, 100).valid?(["group1"])          # => true
  # Groups.new(200, 100, 300).valid?(["default"])         # => true
  # Groups.new(100, 200, 200).valid?("group1", "default") # => false
  # ```
  #
  # ### Generics
  #
  # An assertion can utilize additional generic type variables, other than the required `PropertyType`.  These would then be provided as positional arguments on the assertion annotation.
  #
  # ```
  # @[Assert::Assertions::Register(annotation: Assert::MyCustom)]
  # # A custom assertion that validates if a record exists with the given *id*.
  # #
  # # For example, an ORM model where `.exists?` checks if a record exists with the given PK.
  # # I.e. `SELECT exists(select 1 from "users" WHERE id = 123);`
  # class Exists(PropertyType, Model) < Assert::Assertions::Assertion
  #   initializer(
  #     "@actual": PropertyType
  #   )
  #
  #   # :inherit:
  #   def default_message_template : String
  #     "'{{actual}}' is not a valid {{property_name}}."
  #   end
  #
  #   # :inherit:
  #   def valid? : Bool
  #     # Can use any class method defined on `M`
  #     Model.exists? @actual
  #   end
  # end
  # ```
  # ```
  # class Post < SomeORM::Model
  #   include Assert
  #
  #   def initialize; end
  #
  #   @[Assert::Exists(User)]
  #   property author_id : Int64 = 17
  # end
  # ```
  # This would assert that there is a `User` record with a primary key value of `17`.
  #
  # Of course you can also define named arguments on the annotation if you wanted to, for example, customize the error message on a per annotation basis.
  # ```
  # @[Assert::Exists(User, message: "No user exists with the provided ID")]
  # property author_id : Int64
  # ```
  #
  # ### Extending
  # By default, objects must be validated manually; that is using `Assert#valid?`, `Assert#validate`, or `Assert#validate!` on your own.  This is left up to the user to allow them to
  # control how exactly validation of their objects should work.
  #
  # `Assert` is easy to integrate into existing frameworks/applications.  For example, it could be included in a web framework to automatically run
  # assertions on deserialization, by adding some logic to a `after_initialize` method if using `JSON::Serializable`.  It could also be added into an ORM to check if the object is valid before saving.
  # You could also add logic to an initializer so that it would validate the object on initialization.
  #
  # NOTE: `nil` is considered to be a valid value if the property is nilable.  Either use a non-nilable type, or a `NotNil` assertion.
  abstract class Assertion
    @message : String? = nil

    # The validation groups `self` is a part of.
    getter groups : Array(String)

    # The raw template string that is used to build `#message`.
    getter message_template : String

    # The name of the property `self` was applied to.
    getter property_name : String

    # Sets the *property_name*, and *message*/*groups* if none were provided.
    def initialize(@property_name : String, message : String? = nil, groups : Array(String)? = nil)
      @message_template = message || default_message_template
      @groups = groups || ["default"]
    end

    # Returns the default `#message_template` to use if no *message* is provided.
    abstract def default_message_template : String

    # The message to display if `self` is not valid.
    #
    # NOTE: This method is defined automatically, and is just present for documentation purposes.
    abstract def message : String

    # Returns `true` if a property satisfies `self`, otherwise `false`.
    abstract def valid? : Bool

    # Builds `initialize` with the provided *ivars*.
    #
    # Handles setting the required parent arguments and calling super.
    # ```
    # initializer("@actual": String?, "@some_bool": "Bool = false")
    # # def initialize(
    # #   property_name : String,
    # #   @actual : ::Union(String, ::Nil),
    # #   @some_bool : Bool = false,
    # #   message : String? = nil,
    # #   groups : Array(String)? = nil
    # # )
    # #   super property_name, message, groups
    # # end
    # ```
    macro initializer(**ivars)
      def initialize(
        property_name : String,
        {% for ivar, type in ivars %}
          {{ivar.id}} : {{type.id}},
        {% end %}
        message : String? = nil,
        groups : Array(String)? = nil,
      )
        super property_name, message, groups
      end
    end

    macro inherited
      # :inherit:
      def message : String
        @message ||= @message_template.gsub(/\{\{\w+\}\}/,
          \{% begin %}
            {
              \{% for ivar in @type.instance_vars %}
                "\\{\\{\{{ivar}}}}" => @\{{ivar}},
              \{% end %}
            }
          \{% end %}
        )
      end
    end
  end
end
