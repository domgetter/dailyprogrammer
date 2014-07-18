    def to_bitmap(map, char = "X")
      output = ""
      map.each do |row|
        row.unpack("C")[0].to_s(2).rjust(8, "0").each_char {|cell| output += (cell.to_i == 1) ? char : " " }
        output += "\n"
      end
      output
    end

    rand_chars = [*"!".."~"]
    map = ["\x18", "\x3C", "\x7E", "\x7E", "\x18", "\x18", "\x18", "\x18"]
    puts to_bitmap(map)
    puts

    map = ["\xFF", "\x81", "\xBD", "\xA5", "\xA5", "\xBD", "\x81", "\xFF"]
    puts to_bitmap(map, rand_chars.sample)
    puts

    map = ["\xAA", "\x55", "\xAA", "\x55", "\xAA", "\x55", "\xAA", "\x55"]
    puts to_bitmap(map, rand_chars.sample)
    puts

    map = ["\x3E", "\x7F", "\xFC", "\xF8", "\xF8", "\xFC", "\x7F", "\x3E"]
    puts to_bitmap(map, rand_chars.sample)
    puts

    map = ["\x93", "\x93", "\x93", "\xF3", "\xF3", "\x93", "\x93", "\x93"]
    puts to_bitmap(map, rand_chars.sample)
    puts
