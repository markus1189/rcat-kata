module RCat
  class Display
    def initialize opts={}
      @printer = PrinterFactory.instance(opts)
    end

    def render data
      data.lines.each do |current_line|
        @printer.print current_line
      end
    end
  end
end
