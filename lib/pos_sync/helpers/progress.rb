# frozen_string_literal: true

module Helpers
  class Progress
    def initialize(name, ident = 0)
      puts "#{' ' * ident}Starting to #{name}..."
      @start_time = Time.now
      @end_time = nil
      @ident = ident
      @count = 0
    end

    def next
      print_safe_ident
      print @count != 0 && (@count % 10) == 0 ? @count : '.'
      @count += 1
    end

    def end
      @end_time = Time.now
      seconds = @end_time - @start_time
      print_safe_ident
      puts "Done! (#{@count} in #{human_time(seconds)})"
    end

    private

    def print_safe_ident
      print ' ' * @ident if @count == 0
    end

    def human_time(time)
      minutes, seconds = time.divmod(60)
      hours, minutes = minutes.divmod(60)
      #days, hours = hours.divmod(24)

      #"#{days.to_s.rjust(3)}d #{hours.to_s.rjust(2)}h #{minutes.to_s.rjust(2)}m #{seconds}s"
      "#{hours.to_s.rjust(2)}h #{minutes.to_s.rjust(2)}m #{seconds}s"
    end
  end
end
