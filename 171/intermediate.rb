    class Bitmap

      ZOOMS = [1, 2, 4]
      
      def initialize(map, char = "X")
        @map = map
        @char = char
        @zoom = 1
        @pixel_rows = []
        @rendered = ""
        @rotation = 0
        @inverted = false
        render
      end

      def to_s
        @rendered
      end

      def rotate(angle = 90, direction = :clockwise)
        angle = (angle/90.0).round*90
        case direction
        when :clockwise then @rotation += angle
        when :counterclockwise then @rotation -= angle
        end
        @rotation %= 360
        @rotation /= 90
        rerender
      end

      def zoom_in
        case ZOOMS.index(@zoom)
        when 0 then @zoom = ZOOMS[1]
        when 1 then @zoom = ZOOMS[2]
        end
        rerender
      end

      def zoom_out
        case ZOOMS.index(@zoom)
        when 1 then @zoom = ZOOMS[0]
        when 2 then @zoom = ZOOMS[1]
        end
        rerender
      end
      
      def invert
        @inverted = !@inverted
        rerender
      end

      private
      
      def rerender
        rerender_rotate
        rerender_zoom
        to_s
      end
      
      def rerender_rotate
        if @rotation > 0
          rotated_pixel_rows = Array.new(8) {Array.new}
          @pixel_rows.each_with_index do |row, row_number|
            row.each_with_index do |pixel, column|
              rotated_pixel_rows[column][(@pixel_rows.length-1)-row_number] = pixel
            end
          end
          (@rotation-1).times do
            old_rotated_rows = rotated_pixel_rows
            new_rotated_rows = Array.new(8) {Array.new}
            rotated_pixel_rows.each_with_index do |row, row_number|
              row.each_with_index do |pixel, column|
                new_rotated_rows[column][(@pixel_rows.length-1)-row_number] = pixel
              end
            end
            rotated_pixel_rows = new_rotated_rows
          end
          @rotated_pixel_rows = rotated_pixel_rows
        else
          @rotated_pixel_rows = @pixel_rows
        end
      end

      def rerender_zoom
        new_pixel_rows = []
        @rotated_pixel_rows.each do |row|
          new_row = []
          row.each { |pixel| @zoom.times {new_row << pixel} }
          @zoom.times {new_pixel_rows << new_row}
        end
        new_map = ""
        new_pixel_rows.each {|row| new_map += row.join + "\n" }
        @rendered = new_map.chomp
        if @inverted
          new_map = ""
          @rendered.split("").each {|char| new_map += char.eql?("\n") ? "\n" : (char.eql?(@char) ? " " : @char) }
          @rendered = new_map
        end
      end

      def render
        @map.split.each do |row|
          row.to_hex.unpack("C")[0].to_s(2).rjust(8, "0").each_char {|cell| @rendered += (cell.to_i == 1) ? @char : " " }
          @rendered += "\n"
        end
        @rendered.split("\n").each { |row| @pixel_rows << row.split("") }
      end

    end
    class String
      def to_hex
        eval "\"\\x#{self}\""
      end
    end

    maps = ["FF 81 BD A5 A5 BD 81 FF",
    "AA 55 AA 55 AA 55 AA 55",
    "3E 7F FC F8 F8 FC 7F 3E",
    "93 93 93 F3 F3 93 93 93"]

    maps.each do |map|
      bitmap =  Bitmap.new(map)
      puts bitmap
      puts bitmap.zoom_in
      puts bitmap.rotate
      puts bitmap.zoom_in
      puts bitmap.invert
      puts bitmap.zoom_out
    end
