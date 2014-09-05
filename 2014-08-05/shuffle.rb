def line_shuffle filename
  exit 'no file name' if filename == nil
  
  new_str = File.open(filename).readlines.shuffle
  new_file_name = filename.match(/([^\.]*)(\.[^\.]*)?/)[1] + "-shuffled.txt"
  # /(.+)\.[^\.]*\z/
  new_file = File.open(new_file_name, "w")
  new_str.each do |line|
    new_file.puts(line.chomp)
  end
end

line_shuffle(ARGV[0]) if __FILE__ == $PROGRAM_NAME

