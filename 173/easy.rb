    METRICS = {
      meters_inches: 39.3701,
      meters_miles: 0.000621371,
      meters_attoparsecs: 32.4077929,
      kilograms_pounds: 2.20462,
      kilograms_ounces: 35.274,
      kilograms_hogsheads_of_beryllium: 0.002269
    }
    class String
      def convert
        return unless m = match(/(?<number>\d+(\.\d+)?) (?<old>[\w\s]+) to (?<new>[\w\s]+)/)
        old = m[:old].gsub(" ","_").downcase
        new = m[:new].gsub(" ","_").downcase
        if old.eql? new
          puts "#{m[:number]} #{m[:old]} is #{m[:number]} #{m[:new]}"
        elsif METRICS[(old+"_"+new).to_sym]
          puts "#{m[:number]} #{m[:old]} " +
          "is #{(m[:number].to_f*METRICS[(old+"_"+new).to_sym]).round 2} #{m[:new]}"
        elsif METRICS[(new+"_"+old).to_sym]
          puts "#{m[:number]} #{m[:old]} " +
          "is #{(m[:number].to_f/METRICS[(new+"_"+old).to_sym]).round 2} #{m[:new]}"
        else
          old = METRICS.keys.select {|k| k.to_s.include? old}[0]
          new = METRICS.keys.select {|k| k.to_s.include? new}[0]
          medium = old.to_s.split("_")[0]
          if old && new && old.to_s.split("_")[0].eql?(new.to_s.split("_")[0])
            number = (m[:number].to_f/METRICS[old]*METRICS[new]).round 2
            puts "#{m[:number]} #{m[:old]} is #{number} #{m[:new]}"
          else
            puts "#{m[:number]} #{m[:old]} can't be converted to #{m[:new]}"
          end
        end
      end
    end
    input = ""
    until input.match /^q/i
      print "Please input calculation: "
      input = gets.chomp
      puts input.convert
    end
