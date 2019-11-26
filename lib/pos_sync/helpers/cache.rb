
module Helpers
  class Cache
    def initialize(skip_file_creation = false)
      @skip_file_creation = skip_file_creation
    end

    def write_file(name, data)
      file_name = "#{name}.dump"
      return if File.exists?(file_name) || @skip_file_creation

      puts "  Writing file #{file_name}...".cyanish
      File.open(file_name, 'w') do |file|
        data_as_string = Marshal.dump(data)
        file.write(data_as_string)
      end
    end

    def load_file(name)
      file_name = "#{name}.dump"
      File.open(file_name, 'r') do |file|
        puts "  Loading #{file_name} file...".cyanish
        Marshal.load(file.read)
      end
    rescue Errno::ENOENT => ex
      puts "  Err, #{ex.message}".cyanish
      return nil
    end
  end
end