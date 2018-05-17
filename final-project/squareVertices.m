function [x1,x2,x3,x4,y1,y2,y3,y4] = squareVertices(cx, cy, w, h)
%SQUAREVERTICIES Get the vertices of a given square
x1 = cx - w/2; % bottom left
x2 = cx + w/2; % bottom right
x3 = cx + w/2; % top right
x4 = cx - w/2; % top left
y1 = cy - h/2; % bottom left
y2 = cy - h/2; % bottom right
y3 = cy + h/2; % top right
y4 = cy + h/2; % top left
end

