module RCat

  FileNotFound = Class.new(StandardError)

  class Display
    def initialize opts={}
      @printer = PrinterFactory.instance(opts)
    end

    def render data
      data.lines.each do |current_line|
        @printer.print current_line
      end
    end

    def render_files *files
      Array(files).flatten.each do |file|
        render(read_file(file))
      end
    end

    private

    def read_file file
      File.read(file)
    rescue Errno::ENOENT => err
      raise FileNotFound,
        "rcat: not able to read file: '#{file}'"
    end
  end
end
