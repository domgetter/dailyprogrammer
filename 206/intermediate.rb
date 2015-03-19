radius = 9
input = File.open("field.txt", "r").lines.to_a.join
require 'set'

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

VirtualTile = Struct.new(:x, :y)

class HeatMap
  def initialize(field)
    @tiles = Array.new(field.height) {Array.new(field.width){0}}
  end
  def max_tile
    @tiles.map {|row| row.each_with_index.max}.each_with_index.max_by {|m| m[0]}.flatten
  end
  def increment_tile(relative_tiles_to_water, tile)
    relative_tiles_to_water.each do |relative_tile|
      new_tile_position = VirtualTile.new(relative_tile.x+tile.x, relative_tile.y+tile.y)
      
      if tile.field.contains?(new_tile_position)
        @tiles[new_tile_position.x][new_tile_position.y] += 1
      end
    end
  end
end

def relative_tiles_to_water(radius)
  border_points = [*0..radius].map do |i|
    Math.sqrt(radius**2-i**2).floor
  end
  relative_tiles = Set.new
  border_points.each_with_index do |edge, index|
    [*-edge..edge].each do |p|
      relative_tiles << VirtualTile.new(index,p) << VirtualTile.new(-index,p)
    end
  end
  relative_tiles.delete VirtualTile.new(0, 0)
end

relative_tiles = relative_tiles_to_water(radius)
field = Field.new(input)
watering_map = HeatMap.new(field)
field.each_tile do |tile|
  watering_map.increment_tile(relative_tiles, tile) if tile.has_plant?
end

max, column, row = watering_map.max_tile
puts "Most watered: #{max} plants at [#{row}, #{column}]"