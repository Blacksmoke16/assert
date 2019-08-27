require "../spec_helper"

VALID_LOOSE_EMAILS = [
  "blacksmoke16@eve.tools",
  "example@example.co.uk",
  "fabien_potencier@example.fr",
  "example@example.co..uk",
  "{}~!@!@£$%%^&*().!@£$%^&*()",
  "example@example.co..uk",
  "example@-example.com",
  "example@#{"a"*64}.com",
]

INVALID_LOOSE_EMAILS = [
  "example",
  "example@",
  "example@localhost",
  "foo@example.com bar",
]

VALID_HTML5_EMAILS = [
  "blacksmoke16@eve.tools",
  "example@example.co.uk",
  "blacksmoke_blacksmoke@example.fr",
  "{}~!@example.com",
]

INVALID_HTML5_EMAILS = [
  "example",
  "example@",
  "example@localhost",
  "example@example.co..uk",
  "foo@example.com bar",
  "example@example.",
  "example@.fr",
  "@example.com",
  "example@example.com;example@example.com",
  "example@.",
  " example@example.com",
  "example@ ",
  " example@example.com ",
  " example @example .com ",
  "example@-example.com",
  "example@#{"a"*64}.com",
]

EMAILS_WITH_WHITESPACE = [
  "\x20example@example.co.uk\x20",
  "\x09\x09example@example.co..uk\x09\x09",
  "\x0A{}~!@!@£$%%^&*().!@£$%^&*()\x0A",
  "\x0D\x0Dexample@example.co..uk\x0D\x0D",
  "\x00example@-example.com",
  "example@example.com\x0B\x0B",
]

describe Assert::Email do
  assert_template(Assert::Assertions::Email, "'{{property_name}}' is not a valid email address")

  describe "#valid?" do
    assert_nil(Assert::Assertions::Email)

    describe :loose do
      describe "with valid emails" do
        it "should all be valid" do
          VALID_LOOSE_EMAILS.each do |email|
            Assert::Assertions::Email(String?).new("prop", email).valid?.should be_true
          end
        end
      end

      describe "with invalid emails" do
        it "should all be invalid" do
          INVALID_LOOSE_EMAILS.each do |email|
            Assert::Assertions::Email(String?).new("prop", email).valid?.should be_false
          end
        end
      end
    end

    describe :html5 do
      describe "with valid emails" do
        it "should all be valid" do
          VALID_HTML5_EMAILS.each do |email|
            Assert::Assertions::Email(String?).new("prop", email, mode: :html5).valid?.should be_true
          end
        end
      end

      describe "with invalid emails" do
        it "should all be invalid" do
          INVALID_HTML5_EMAILS.each do |email|
            Assert::Assertions::Email(String?).new("prop", email, mode: :html5).valid?.should be_false
          end
        end
      end
    end

    describe :normalizer do
      it "should be normalized to be valid" do
        EMAILS_WITH_WHITESPACE.each do |email|
          Assert::Assertions::Email(String?).new("prop", email, normalizer: ->(actual : String) { actual.strip }).valid?.should be_true
        end
      end
    end
  end
end
