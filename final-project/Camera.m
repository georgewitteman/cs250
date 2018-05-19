classdef Camera < handle
  %CAMERA
  
  properties (Constant)
    Debug = false
  end
  
  properties
    MaxDistance
    ViewAngle
    Color
    CameraOn
  end
  
  methods(Static)
    function ang = getAngleOffCenter(cam_x, cam_y, cam_R, obj_x, obj_y)
      %GETANGLEOFFCENTER
      % Calculate the angle of the object relative to the center
      % axis of the camera.
      cam_x2 = cos(deg2rad(cam_R)) + cam_x;
      cam_y2 = sin(deg2rad(cam_R)) + cam_y;
      
      if Camera.Debug
        plot([cam_x cam_x2], [cam_y cam_y2]);
        plot([cam_x obj_x], [cam_y obj_y]);
      end
      
      % Find the angle between the two lines created by the points
      ang = rad2deg(atan2(obj_y-cam_y, obj_x-cam_x) - ...
        atan2(cam_y2-cam_y,cam_x2-cam_x));
      
      % Correct for error
      if ang > 180
        ang = ang - 360;
      end
    end
  end
  
  methods
    function obj = Camera(maxDistance,viewAngle,color,cameraOn)
      %CAMERA Construct an instance of this class
      obj.MaxDistance = maxDistance;
      obj.ViewAngle = viewAngle;
      obj.Color = color;
      obj.CameraOn = cameraOn;
    end
    
    function pgon = getPolyshape(obj, cam_x, cam_y, cam_R)
      %GETPOLYSHAPE Get the polyshape for the given camera position
      t = 0.0:0.1:2*pi;
      
      % Get the multiplier for the x positions of the triangle
      a = obj.MaxDistance/cos(deg2rad(obj.ViewAngle)/2);
      
      % Get the x/y positions for the triangle
      x1 = cam_x;
      y1 = cam_y;
      x2 = cam_x + a * sin(deg2rad(obj.ViewAngle)/2);
      y2 = cam_y + obj.MaxDistance;
      x3 = cam_x + -a * sin(deg2rad(obj.ViewAngle)/2);
      y3 = cam_y + obj.MaxDistance;
      
      % Generate the triangle
      tri = polyshape([x1 x2 x3], [y1 y2 y3]);
      
      % Generate the circle
      x_circ = obj.MaxDistance * cos(t) + cam_x;
      y_circ = obj.MaxDistance * sin(t) + cam_y;
      circ = polyshape(x_circ,y_circ);
      
      % Generate the rotated intersection of the circle and triangle
      both = intersect(tri,circ);
      pgon = rotate(both,cam_R-90,[cam_x,cam_y]);
    end
    
    function TF = inFieldOfView(obj, cam_x, cam_y, cam_R, obj_x, obj_y)
      %INFIELDOFVIEW
      
      fieldOfView = obj.getPolyshape(cam_x, cam_y, cam_R);
      TF = isinterior(fieldOfView,obj_x,obj_y);
    end
      
    function draw(obj, cam_x, cam_y, cam_R)
      if obj.CameraOn
        fieldOfView = obj.getPolyshape(cam_x, cam_y, cam_R);
        p = plot(fieldOfView);
        p.FaceColor = obj.Color;
        p.FaceAlpha = 0.05;
        p.LineStyle = 'none';
      end
    end
  end
end

