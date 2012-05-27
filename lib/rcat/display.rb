module RCat
  class Display
    NUMBER_WIDTH = 6
    FILL_CHAR = ' '
    attr_reader :stdout
    def initialize(stdout = STDOUT,
                   fill_char = FILL_CHAR,
                   number_width = NUMBER_WIDTH)


      @number_width = number_width
      @fill_char = fill_char
      @stdout = stdout

      @line_number = 1
      @numbering = :none
    end

    def enable_numbering
      @numbering = :all if @numbering != :significant
    end

    def enable_squeeze
      @squeeze = true
    end

    def enable_significant_numbering
      @numbering = :significant
    end

    def render(data)
      lines = data.lines
      loop { render_line(lines) }
    end

    private

    attr_reader :numbering, :squeeze

    def render_line(lines)
      current_line = lines.next

      case numbering
      when :none
        print_without_number(current_line)
      when :significant
        if current_line.chomp.empty?
          print_without_number(current_line)
        else
          print_numbered(current_line)
        end
      when :all
        print_numbered(current_line)
      else fail "Unexpected case: #{numbering}"
      end

      if squeeze && current_line.chomp.empty?
        lines.next while lines.peek.chomp.empty?
      end
    end

    def print_numbered(line)
      stdout.puts "#{@line_number.to_s.rjust(@number_width, @fill_char)}\t#{line}"
      increment_line_number
    end

    def print_without_number(line)
      stdout.puts line
    end

    def increment_line_number
      @line_number += 1
    end
  end
end
