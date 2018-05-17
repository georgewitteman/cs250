classdef Block < handle
  %BLOCK A block on the arena
  
  properties (Constant)
    Width = 1.5/12 % inches
    Height = 1.5/12 % inches
  end
  
  properties
    X % feet
    Y % feet
    Color
  end
  
  methods
    function obj = Block(x, y, color)
      %BLOCK Construct a block on the arena
      obj.X = x;
      obj.Y = y;
      obj.Color = color;
    end
    
    function draw(obj)
      %DRAW Draw the block on the arena
      [x1,x2,x3,x4,y1,y2,y3,y4] = ...
        squareVertices(obj.X, obj.Y, Block.Width, Block.Height);
      
      pgon = polyshape([x1 x2 x3 x4], [y1 y2 y3 y4]);
      
      p = plot(pgon);
      p.FaceAlpha = 1;
      p.FaceColor = obj.Color;
      p.EdgeColor = 'black';
      p.LineWidth = 0.5;
    end
  end
end

