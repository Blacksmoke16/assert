require "spec"
require "../src/assert"

# Define a nil value test case for *type* should be *valid*.
macro assert_nil(assertion, type_vars = [String?], valid = true, **args)
  describe "with a nil value" do
    it %(should #{{{valid ? "" : "not"}}} be valid) do
      {{assertion.id}}({{type_vars.splat}}).new("prop", nil, {{args.double_splat}}).valid?.should be_{{valid.id}}
    end
  end
end

# Defines a test case for testing *type*'s default_message_template equals *message*.
macro assert_template(type, message, type_vars = [String?], **args)
  describe "#default_message_template" do
    it "should return the proper default template string" do
      {{type.id}}({{type_vars.splat}}).new("prop", nil, {{args.double_splat}}).default_message_template.should eq {{message}}
    end
  end
end
