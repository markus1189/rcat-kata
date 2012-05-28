module RCat
  class PrinterFactory
    def self.instance opts
      result = Printer.new

      number_lines       = opts.fetch(:number) { false }
      number_significant = opts.fetch(:number_significant) { false }
      squeeze            = opts.fetch(:squeeze) { false }

      if number_lines || number_significant
        result = NumberedPrinter.new(result,
                                     :number_significant => number_significant)
      end

      result = SqueezeMultipleBlankPrinter.new(result) if squeeze

      result
    end
  end

  class Printer
    def print str
      puts str
    end
  end

  class NumberedPrinter
    def initialize wrapped, opts
      @wrapped = wrapped
      @line_number = 1
      @number_significant = opts.fetch(:number_significant)
    end

    def print line
      if not number_significant? or not line.chomp.empty?
        $stdout.print "#{@line_number.to_s.rjust(6)}\t"
        increment_line_number
      end
      @wrapped.print line
    end

    private

    def number_significant?
      @number_significant
    end

    def increment_line_number
      @line_number += 1
    end
  end

  class SqueezeMultipleBlankPrinter
    def initialize wrapped
      @wrapped = wrapped
      @last_line = "not empty"
    end

    def print line
      if not (line.chomp.empty? && last_line_was_empty?)
        @wrapped.print line
      end
      @last_line = line
    end

    def last_line_was_empty?
      @last_line.chomp.empty?
    end
  end
end
