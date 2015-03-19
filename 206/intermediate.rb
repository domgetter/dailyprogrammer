radius = 9
input = File.open("field.txt", "r").lines.to_a.join

class Plot
  def initialize(field, x, y)
  
  end
end

class Field
  attr_reader :plots
  def initialize(str)
    @plots = str.split.map {|s| s.split ""}
  end
  def length
    @plots.length
  end
  def [](*args)
    @plots[*args]
  end
end

def relative_tiles_to_water(radius)
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
  relative_tiles
end

def tile_has_plant?(cell)
  cell.eql? "x"
end

def tile_to_water_is_on_field(tile, x, y, field)
  tile[0]+x >=0 &&
  tile[1]+y >=0 &&
  tile[0]+x < field.length &&
  tile[1]+y < field[0].length
end

def add_points_to_tiles_that_water_the_plant(map, relative_tiles_to_water, x, y, field)
  relative_tiles_to_water.each do |tile|
    if tile_to_water_is_on_field(tile, x, y, field)
      map[tile[0]+x][tile[1]+y] += 1
    end
  end
end

def max_of(watering_map)
  watering_map.map {|row| row.each_with_index.max}.each_with_index.max_by {|m| m[0]}.flatten
end

def field_of_zeros(field)
  Array.new(field.length) {Array.new(field[0].length){0}}
end

relative_tiles = relative_tiles_to_water(radius)
field = Field.new(input)
watering_map = field_of_zeros(field)
field.plots.each_with_index do |row, x|
  row.each_with_index do |cell, y|
    if tile_has_plant?(cell)
      add_points_to_tiles_that_water_the_plant(watering_map, relative_tiles, x, y, field)
    end
  end
end

max, column, row = max_of(watering_map)
puts "Most watered: #{max} plants at [#{row}, #{column}]"