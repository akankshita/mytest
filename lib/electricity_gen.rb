class Time
  def step(other_time, increment)
   raise ArgumentError, "step can't be 0" if increment == 0
    increasing = self < other_time
    if (increasing && increment < 0) || (!increasing && increment > 0)
      yield self
      return
      end
      d = self
    begin
      yield d
      d += increment
    end while (increasing ? d <= other_time : d >= other_time)
  end

  def upto(other_time)
    step(other_time, 1) { |x| yield x }
  end
end

the_first = Time.local(2010, 2, 1)
the_second = Time.local(2010, 2, 15)
output = String.new
the_first.step(the_second, 60 * 30) { |x| output = output + "#{rand(5000)}, #{x}, #{ARGV[0]}\n" }

File.open("output_#{ARGV[0]}.csv", 'w') {|f| f.write(output) }	