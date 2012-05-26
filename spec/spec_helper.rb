class PipeWrapper
  attr_reader :stdout, :stderr, :process

  def initialize stdout, stderr, process
    @stdout = stdout
    @stderr = stderr
    @process = process
  end

  def self.[] stdout, stderr, process
    new(stdout, stderr, process)
  end
end

def output_should_equal_on *args
  arg_str = args.join(' ')

  cat_out , cat_err , cat_process  = Open3.capture3("cat  #{arg_str}")
  rcat_out, rcat_err, rcat_process = Open3.capture3("rcat #{arg_str}")

  if block_given?
    yield(
      PipeWrapper[cat_out, cat_err, cat_process],
      PipeWrapper[rcat_out, rcat_err, rcat_process]
    )
  else
    rcat_out.should eq(cat_out)
  end
end

def gettysburg_file
  gettysburg_file = "#{data_dir}/gettysburg.txt"
end

def spaced_file
  spaced_file = "#{data_dir}/spaced_out.txt"
end

def data_dir
  data_dir = "#{File.dirname(__FILE__)}/../data"
end


