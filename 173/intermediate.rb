require 'curses'
include Curses
init_screen
Pixel = Struct.new(:x, :y, :color)
Point = Struct.new(:x, :y)
class Map
  attr_reader :grid
  def initialize
    #10x10 grid of pixels
    @grid = Array.new(50) {Array.new}
    @grid.each_with_index do |pixels, row|
      100.times do |column|
        pixels << Pixel.new(row, column, [:white].sample)
      end
    end
  end
  def color_at(point)
    @grid[point.x][point.y].color
  end
  def pixel_at(point)
    @grid[point.x][point.y]
  end
  def draw
    setpos(0,0)
    @grid.each do |row|
      row.each do |pixel|
        addch(pixel.color.eql?(:black) ? " " : "X")
      end
      addch("\n")
    end
    refresh
  end
end
class Ant
  DIRECTIONS = [:up, :right, :down, :left]
  def initialize(map)
    @position = Point.new(rand(50), rand(100))
    @directions = DIRECTIONS.cycle
    (rand 4).times {@directions.next}
    @direction = @directions.next
    @map = map
  end
  def step
    case @map.color_at(@position)
    when :white 
      turn(:clockwise)
      @map.pixel_at(@position).color = :black
    when :black
      turn(:counterclockwise)
      @map.pixel_at(@position).color = :white
    end
    case @direction
    when :up then @position.y -= 1
    when :down then @position.y += 1
    when :left then @position.x -= 1
    when :right then @position.x += 1
    end
    @position.x %= 50
    @position.y %= 100
    
  end
  def turn(direction)
    if direction.eql? :counterclockwise
      2.times {@directions.next}
    end
    @direction = @directions.next
  end
end
map = Map.new
ants = []
3.times {ants << Ant.new(map)}
loop do
  ants.each {|ant| ant.step}
  map.draw
end