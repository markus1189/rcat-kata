class Printer
  attr_reader :stdout
  def initialize stdout=$stdout
    @stdout = stdout
  end

  def print line
    stdout.puts line
  end
end
