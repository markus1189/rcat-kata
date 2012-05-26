# Task: Implement the rcat utility and get these tests to pass on a system
# which has the UNIX cat command present
#
# To see Gregory Brown's solution, see:
# http://github.com/elm-city-craftworks/rcat
#
# Feel free to publicly share your own solutions
#
# If you want to see detailed commentary on how to solve this problem
# please subscribe to the Practicing Ruby Journal ( practicingruby.com )
# An article on this topic will be released on Tuesday 10/18.

require "open3"
require "ostruct"
require "rcat"

require "spec_helper"

describe RCat do

  before :all do
    $stderr = $stdout
  end

  it "can write a file to stdout like cat" do
    output_should_equal_on gettysburg_file
  end

  it "can write multiple files" do
    output_should_equal_on gettysburg_file, spaced_file
  end

  it "reads files from stdin" do
    output_should_equal_on "<", spaced_file
  end

  context "with one flag" do

    it "can number lines" do
      output_should_equal_on "-n", gettysburg_file
    end

    it "ignores empty lines while numbering on -b flag" do
      output_should_equal_on "-b", gettysburg_file
    end

    it "squeezes mulitple empty lines" do
      output_should_equal_on "-s", spaced_file
    end

    it "should print usage on bad flag" do
      output_should_equal_on "--fail", gettysburg_file do |cat_info, rcat_info|
        rcat_info.stderr.should ==
          "rcat: invalid option: --fail\nusage: rcat [-bns] [file ...]\n"
      end
    end

  end

  context "with two flags" do

    it "can squeeze and ignore blank lines" do
      output_should_equal_on "-bs", spaced_file
    end

    it "can number and squeeze" do
      output_should_equal_on "-ns", gettysburg_file, spaced_file
    end

    it "can squeeze and ignore blank lines" do
      output_should_equal_on "-bs", gettysburg_file, spaced_file
    end

  end

  context "with three flags" do

    it "can ignore blank, number lines and squeeze" do
      output_should_equal_on "-bns", spaced_file
    end

    it "does not matter in what order the flags are" do
      output_should_equal_on "-nbs", spaced_file
      output_should_equal_on "-sbn", spaced_file
    end

  end

  context "testing exit status" do
    it "should succeed on a single file" do
      `cat #{gettysburg_file}`
      cat_success = $?
        `#{executable_dir}/rcat #{gettysburg_file}`
      rcat_success = $?

        cat_success.exitstatus.should eq(0)
      rcat_success.should == cat_success
    end

    it "should fail like cat on an invalid file" do
      `cat invalid 2>/dev/null`
      cat_success = $?
        `#{executable_dir}/rcat invalid 2>/dev/null`
      rcat_success = $?

        cat_success.exitstatus.should_not eq(0)
      rcat_success.should == cat_success
    end
  end

  context "printing error messages" do
    it "rcats error message should equal cat's" do
      output_should_equal_on "some_invalid_file", "2>/dev/null"
    end
  end
end
