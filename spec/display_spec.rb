require "spec_helper"

include RCat

describe Display do
  let(:captured) { StringIO.new }

  before do
    @stdout_before = $stdout
    $stdout = captured
  end

  after do
    $stdout = @stdout_before
  end

  it "renders normal input" do
    input = "What is Life's greates illusion?\nInnocence my brother."
    expected = `echo "#{input}" | cat`

    display = Display.new
    display.render(input)
    captured.string.should eq(expected)
  end

  it "can number lines" do
    input = "One\nTwo\nThree"
    expected = `echo "#{input}" | cat -n`

    display = Display.new(number: true)
    display.render(input)
    captured.string.should eq(expected)
  end

  it "puts no numbers on blank lines if significant numbering active" do
    input    = "One\n\nTwo\n\nThree"
    expected = `echo "#{input}" | cat -b`

    display = Display.new(number: true, number_significant: true)
    display.render(input)
    captured.string.should eq(expected)
  end

  it "numbers trailing empty lines" do
    input    = "Test\n\n"
    expected = `echo -n "#{input}" | cat -n`

    display = Display.new(number: true)
    display.render(input)
    captured.string.should eq(expected)
  end

  it "squeezes extra blank lines" do
    input    = "Line one\n\n\nAfter 2 blank"
    expected = `echo "#{input}" | cat -s`

    display = Display.new(squeeze: true)
    display.render(input)
    captured.string.should eq(expected)
  end

  it "can display a file from disk" do
    input = "I am a little temporary file, please cat me!"
    file = Tempfile.new('test')
    file.write input
    expected = `cat #{file.path}`

    display = Display.new
    display.render_files file
    captured.string.should eq(expected)
  end

  it "raises an error if a file could not be read" do
    file = stub(:path => "catch me if you can")
    expect {
      Display.new.render_files file
    }.to raise_error(RCat::FileNotFound)
  end
end

