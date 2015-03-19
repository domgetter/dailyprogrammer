radius = 9
input = File.open("field.txt", "r").lines.to_a.map &:chomp
indices = [*0..radius].map do |i|
  [*-Math.sqrt(radius**2-i**2).floor..Math.sqrt(radius**2-i**2).floor]
end
indices[0].delete_at radius
watering_rows = {}
indices.each_with_index do |row, index|
 watering_rows[index] = row
 watering_rows[-index] = row
end
relative_tiles = []
watering_rows.each do |row, columns|
  columns.each {|column| relative_tiles << [row, column]}
end
field = input.map {|s| s.split ""}
sprinkler_sums = Array.new(field.length) {Array.new(field[0].length){0}}
field.each_with_index do |row, x|
  row.each_with_index do |cell, y|
    if cell.eql? "x"
      relative_tiles.each do |point|
        if point[0]+x >=0 && point[1]+y >=0 && point[0]+x < field.length && point[1]+y < field[0].length
          sprinkler_sums[point[0]+x][point[1]+y] += 1
        end
      end
    end
  end
end
max, column, row = sprinkler_sums.map {|row| row.each_with_index.max}.each_with_index.max_by {|m| m[0]}.flatten
puts "Most watered: #{max} plants at [#{row}, #{column}]"