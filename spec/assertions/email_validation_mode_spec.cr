require "../spec_helper"

describe Assert::Assertions::Email::EmailValidationMode do
  describe "#get_pattern" do
    describe Assert::Assertions::Email::EmailValidationMode::Loose do
      it "should return the correct Regex" do
        Assert::Assertions::Email::EmailValidationMode::Loose.get_pattern.should eq /^.+\@\S+\.\S+$/
      end
    end

    describe Assert::Assertions::Email::EmailValidationMode::HTML5 do
      it "should return the correct Regex" do
        Assert::Assertions::Email::EmailValidationMode::HTML5.get_pattern.should eq /^[a-zA-Z0-9.!\#$\%&\'*+\\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$/
      end
    end

    describe Assert::Assertions::Email::EmailValidationMode::Strict do
      it "should raise an NotImplementedError" do
        expect_raises(NotImplementedError, "Unsupported pattern: Strict") do
          Assert::Assertions::Email::EmailValidationMode::Strict.get_pattern
        end
      end
    end
  end
end
