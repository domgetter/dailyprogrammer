class Vertex

  attr_reader :x, :y

  def initialize(vert)
    vert = vert.split(",")
    @x = vert[0].to_f
    @y = vert[1].to_f
  end
  
  def to_s
    "(#@x, #@y)"
  end
  
  def d_to(other_vert)
    Math.sqrt((other_vert.x-@x)**2+(other_vert.y-@y)**2)
  end
  
end

class Polygon

  def initialize(map)
    map = map.split("\n")
    @sides = map[0].to_i
    @vertices = []
    map[1..-1].each do |vertex|
      @vertices << Vertex.new(vertex)
    end
    @vertices_to_path = @vertices.dup
    @path = [@vertices_to_path.pop]
    until @vertices_to_path.one?
      segs = [@path.last].product(@vertices_to_path)
      shortest = segs.min_by {|s| s[0].d_to s[1] }
      @path << shortest[1]
      @vertices_to_path.delete(shortest[1])
    end
    @path << @vertices_to_path.pop
    
  end
  
  def area
    @area ||= calculate_area
  end
  
  private
  
  def calculate_area
    triangles = []
    (1..(@sides-2)).each do |i|
      triangles << [@path[0], @path[i], @path[i+1]]
    end
    puts triangles.inspect
    total_area = 0.0
    triangles.each do |t|
      area = ((t[0].x*(t[1].y-t[2].y)+t[1].x*(t[2].y-t[0].y)+t[2].x*(t[0].y-t[1].y))/2.0).abs
      total_area += area
    end
    total_area
  end
  
end
shape = "5
1,1
0,2
1,4
4,3
3,2"

poly = Polygon.new(shape)
puts poly.area

shape = "8
-4,3
1,3
2,2
2,0
1.5,-1
0,-2
-3,-1
-3.5,0"

poly = Polygon.new(shape)
puts poly.area
