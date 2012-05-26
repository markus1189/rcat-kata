module RCat
  class Display
    def initialize(params)
      @line_number = 1
    end

    def enable_numbering
      @numbering = true
    end

    def enable_squeeze
      @squeeze = true
    end

    def enable_ignore_blank
      @ignore_blank_lines = true
    end

    def render(data)
      lines = data.lines
      loop { render_line(lines) }
    end

    private

    attr_reader :numbering, :squeeze, :ignore_blank_lines

    def render_line(lines)
      current_line = lines.next
      current_line_is_blank = current_line.chomp.empty?

      line_numbering_style = :all_lines if numbering && !ignore_blank_lines
      line_numbering_style = :significant_lines if (numbering && ignore_blank_lines) || ignore_blank_lines

      case line_numbering_style
      when :all_lines
        print_labeled_line(current_line)
        increment_line_number
      when :significant_lines
        if current_line_is_blank
          print_unlabeled_line(current_line)
        else
          print_labeled_line(current_line)
          increment_line_number
        end
      else
        print_unlabeled_line(current_line)
        increment_line_number
      end

      if squeeze && current_line_is_blank
         lines.next while lines.peek.chomp.empty?
      end
    end

    def print_labeled_line(line)
      print "#{@line_number.to_s.rjust(6)}\t#{line}"
    end

    def print_unlabeled_line(line)
      print line
    end

    def increment_line_number
      @line_number += 1
    end
  end
end
