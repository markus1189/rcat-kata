require "spec_helper"

include RCat

describe Display do
  let(:captured) { StringIO.new }
  let(:display) { Display.new(captured) }

  let(:db) {  }

  it "renders normal input" do
    input = "What is Life's greates illusion?\nInnocence my brother."
    expected = `echo "#{input}" | cat`

    display.render(input)
    captured.string.should eq(expected)
  end

  it "can number lines" do
    input = "One\nTwo\nThree"
    expected = `echo "#{input}" | cat -n`

    display.enable_numbering
    display.render(input)
    captured.string.should eq(expected)
  end

  it "puts no numbers on blank lines if significant numbering active" do
    input    = "One\n\nTwo\n\nThree"
    expected = `echo "#{input}" | cat -b`

    display.enable_significant_numbering
    display.render(input)
    captured.string.should eq(expected)
  end
end

