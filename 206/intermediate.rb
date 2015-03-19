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
end

class VirtualField
  def initialize(field)
    @tiles = Array.new(field.height) {Array.new(field.width){0}}
  end
  def max_tile
    @tiles.map {|row| row.each_with_index.max}.each_with_index.max_by {|m| m[0]}.flatten
  end
  def add_points_to_tiles_that_water_the_plant(relative_tiles_to_water, tile)
    relative_tiles_to_water.each do |relative_tile|
      if tile_to_water_is_on_field(relative_tile, tile.x, tile.y, tile.field)
        @tiles[relative_tile[0]+tile.x][relative_tile[1]+tile.y] += 1
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

def tile_to_water_is_on_field(tile, x, y, field)
  tile[0]+x >=0 &&
  tile[1]+y >=0 &&
  tile[0]+x < field.height &&
  tile[1]+y < field.width
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