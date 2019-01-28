function corners_3D = computeBox3D(object)
% takes an object and computes 8 corners of the Bounding Box.



% compute rotational matrix around yaw axis
R = [+cos(object.ry), 0, +sin(object.ry);
                   0, 1,               0;
     -sin(object.ry), 0, +cos(object.ry)];

% 3D bounding box dimensions
l = object.l;
w = object.w;
h = object.h;

% 3D bounding box corners
x_corners = [l/2, l/2, -l/2, -l/2, l/2, l/2, -l/2, -l/2];
y_corners = [0,0,0,0,-h,-h,-h,-h];
z_corners = [w/2, -w/2, -w/2, w/2, w/2, -w/2, -w/2, w/2];

% rotate and translate 3D bounding box
corners_3D = R*[x_corners;y_corners;z_corners];
corners_3D(1,:) = corners_3D(1,:) + object.t(1);
corners_3D(2,:) = corners_3D(2,:) + object.t(2);
corners_3D(3,:) = corners_3D(3,:) + object.t(3);


