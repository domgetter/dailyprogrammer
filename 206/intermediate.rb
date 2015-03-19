radius = 9
input = File.open("field.txt", "r").lines.to_a.join

class Tile
  attr_reader :x, :y, :field
  def initialize(field, x, y, contents)
    @field = field
    @x = x
    @y = y
    @contents = contents
  end

  def has_plant?
    @contents.eql? "x"
  end
end

class Field
  attr_reader :tiles, :width, :height
  def initialize(str)
    tiles = str.split.map {|s| s.split ""}
    @tiles = []
    @width = tiles[0].length
    @height = tiles.length
    tiles.each_with_index do |row, x|
      row.each_with_index do |tile_contents, y|
        @tiles << Tile.new(self, x, y, tile_contents)
      end
    end
  end
  def each_tile &block
    @tiles.each &block
  end

  def contains?(new_tile_position)
    (0..(height-1)).include?(new_tile_position.x) &&
    (0..(width-1)).include?(new_tile_position.y)
  end
end

class VirtualField
  VirtualTile = Struct.new(:x, :y)
  def initialize(field)
    @tiles = Array.new(field.height) {Array.new(field.width){0}}
  end
  def max_tile
    @tiles.map {|row| row.each_with_index.max}.each_with_index.max_by {|m| m[0]}.flatten
  end
  def add_points_to_tiles_that_water_the_plant(relative_tiles_to_water, tile)
    relative_tiles_to_water.each do |relative_tile|
      new_tile_position = VirtualTile.new(relative_tile[0]+tile.x, relative_tile[1]+tile.y)
      
      if tile.field.contains?(new_tile_position)
        @tiles[new_tile_position.x][new_tile_position.y] += 1
      end
    end
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

relative_tiles = relative_tiles_to_water(radius)
field = Field.new(input)
watering_map = VirtualField.new(field)
field.each_tile do |tile|
  if tile.has_plant?
    watering_map.add_points_to_tiles_that_water_the_plant(relative_tiles, tile)
  end
end

max, column, row = watering_map.max_tile
puts "Most watered: #{max} plants at [#{row}, #{column}]"