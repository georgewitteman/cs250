function polyout = getPolyshape(cx, cy, w, h, r)
%GETPOLYSHAPE Get polyshape for the given parameters

% Reverse the h and w because of the 90deg default rotation

x1 = cx - h/2; % bottom left
x2 = cx + h/2; % bottom right
x3 = cx + h/2; % top right
x4 = cx - h/2; % top left
y1 = cy - w/2; % bottom left
y2 = cy - w/2; % bottom right
y3 = cy + w/2; % top right
y4 = cy + w/2; % top left

% Generate unrotated POLYSHAPEO
pgon = polyshape([x1 x2 x3 x4], [y1 y2 y3 y4]);

% Rotate
polyout = rotate(pgon, r, [cx cy]);
end

