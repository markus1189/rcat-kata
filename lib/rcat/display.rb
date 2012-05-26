module RCat
  class Display
    def initialize(params)
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
      current_line_is_blank = current_line.chomp.empty?

      case numbering
      when :none
        print_unlabeled_line(current_line)
      when :significant
        if current_line_is_blank
          print_unlabeled_line(current_line)
        else
          print_labeled_line(current_line)
        end
      when :all
          print_labeled_line(current_line)
      else fail "Unexpected case: #{numbering}"
      end

      if squeeze && current_line_is_blank
        lines.next while lines.peek.chomp.empty?
      end
    end

    def print_labeled_line(line)
      print "#{@line_number.to_s.rjust(6)}\t#{line}"
      increment_line_number
    end

    def print_unlabeled_line(line)
      print line
    end

    def increment_line_number
      @line_number += 1
    end
  end
end
