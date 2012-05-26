require "spec_helper"

include RCat

describe Display do
  let(:captured) { StringIO.new }
  let(:display) { Display.new(captured, '.') }

  let(:db) { %Q{
      What is Life's greates illusion?
      Innocence my brother.
    } }

  it "renders normal input" do
    display.render(db)
    captured.string.should eq(db)
  end

  it "puts no numbers on blank lines if significant numbering active" do
    input    = "One\n\nTwo\n\nThree\n"
    expected = ".....1\tOne\n\n.....2\tTwo\n\n.....3\tThree\n"

    display.enable_significant_numbering
    display.render(input)
    captured.string.should eq(expected)
  end
end

