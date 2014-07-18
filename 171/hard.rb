    class String
      SIX_BIT = Hash.new { |h, i| h[i] = i.to_s(2).rjust(6, "0") }
      SIX_BIT_CHARS = [*"A".."Z", *"0".."9", " "]
      def sb_compress
        output = ""
        self.each_char do |char|
          output += SIX_BIT[SIX_BIT_CHARS.index(char)]
        end
        output
      end
      def sb_decompress
        output = ""
        self.chars.each_slice(6) do |char|
          output += SIX_BIT_CHARS[char.join.to_i(2)]
        end
        output
      end
    end

    def console_output(message)
      compressed_message = message.sb_compress
      decompressed_message = compressed_message.sb_decompress
      puts "Read Message of #{message.length} Bytes."
      puts "Compressing #{message.length*8} Bits into " +
        "#{compressed_message.length} Bits. " +
        "(#{100*((message.length*8-compressed_message.length).to_f/
        (message.length*8)).round(2)}% compression)"
      puts "Sending Message."
      puts "Decompressing Message into #{decompressed_message.length} Bytes."
      if decompressed_message.eql? message
        puts "Message Matches!"
      end
    end

    messages = ["REMEMBER TO DRINK YOUR OVALTINE",
      "GIANTS BEAT DODGERS 10 TO 9 AND PLAY TOMORROW AT 1300",
      "SPACE THE FINAL FRONTIER THESE ARE THE VOYAGES OF THE BIT STREAM DAILY " +
      "PROGRAMMER TO SEEK OUT NEW COMPRESSION"]

    messages.each {|message| console_output message; puts }