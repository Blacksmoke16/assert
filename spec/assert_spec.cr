require "./spec_helper"

class Test
  include Assert

  def initialize(@group_1 : Int32, @group_2 : Int32, @default_group : Int32); end

  @[Assert::EqualTo(value: 100, groups: ["group1"])]
  property group_1 : Int32

  @[Assert::EqualTo(value: 200, groups: ["group2"])]
  property group_2 : Int32

  @[Assert::EqualTo(value: 300)]
  property default_group : Int32
end

class SomeClass
  include Assert

  def initialize; end

  @[Assert::Size(Range(Int32, Int32), range: 5..5)]
  property exact_value : String = "he"
end

describe Assert do
  describe "#valid?" do
    describe "with a valid object" do
      it "should return true" do
        Test.new(100, 200, 300).valid?.should be_true
      end
    end

    describe "with an invalid object" do
      it "should return false" do
        Test.new(100, 100, 300).valid?.should be_false
      end
    end

    describe :groups do
      describe Array do
        it "should run assertions in that group" do
          Test.new(100, 100, 100).valid?(["group1"]).should be_true
        end
      end

      describe "splat" do
        it "should run assertions in that group" do
          Test.new(100, 100, 100).valid?(["group1"]).should be_true
        end
      end

      describe "default" do
        it "assertions without explicit groups should be in the default group" do
          Test.new(200, 100, 300).valid?(["default"]).should be_true
        end
      end
    end
  end

  describe "#validate" do
    it "should preserve the message if it was changed" do
      SomeClass.new.validate.first.message.should eq "'exact_value' is not the proper size.  It should have exactly 5 character(s)"
    end

    describe "with a valid object" do
      it "should return an empty array" do
        Test.new(100, 200, 300).validate.should be_empty
      end
    end

    describe "with an invalid object" do
      it "should return a non empty array" do
        Test.new(100, 100, 100).validate.should_not be_empty
      end
    end

    describe :groups do
      describe Array do
        it "should run assertions in that group" do
          Test.new(50, 200, 100).validate(["group2"]).should be_empty
        end
      end

      describe "splat" do
        it "should run assertions in that group" do
          Test.new(100, 250, 100).validate("group1").should be_empty
        end
      end

      describe "default" do
        it "assertions without explicit groups should be in the default group" do
          Test.new(200, 100, 300).validate(["default"]).should be_empty
        end
      end
    end
  end

  describe "#validate!" do
    it "should preserve the message if it was changed" do
      SomeClass.new.validate!
    rescue ex : Assert::Exceptions::ValidationError
      ex.to_s.should eq "Validation tests failed:  'exact_value' is not the proper size.  It should have exactly 5 character(s)"
    end

    describe "with a valid object" do
      it "should return true" do
        Test.new(100, 200, 300).validate!.should be_nil
      end
    end

    describe "with an invalid object" do
      it "should raise the proper exception" do
        expect_raises(Assert::Exceptions::ValidationError, "Validation tests failed") do
          Test.new(100, 100, 100).validate!
        end
      end
    end

    describe :groups do
      describe Array do
        it "should run assertions in that group" do
          Test.new(50, 200, 150).validate!(["group2"]).should be_nil
        end
      end

      describe "splat" do
        it "should run assertions in that group" do
          Test.new(100, 250, 150).validate!("group1").should be_nil
        end
      end

      describe "default" do
        it "assertions without explicit groups should be in the default group" do
          Test.new(200, 100, 300).validate!(["default"]).should be_nil
        end
      end
    end
  end
end
