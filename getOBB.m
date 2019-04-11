function[OBB] = getOBB(corners)
%getOBB returns cell array of bounding boxes for objects
%args:
%  corners: cell array of corners, one cell per object
%returns:
%  OBB: cell array of bounding boxes, one cell per object

%   [3]
%   ^    [6]
%   |   /
% v |  / w
%   | /
%  [2] -----> [1]
%         u

Nobj = size(corners,2);

for i = 1: Nobj
    %%%% getting axes
    u = (corners{i}(:,1) - corners{i}(:,2));
    OBB{i}.u = u/norm(u);
    v = (corners{i}(:,3) - corners{i}(:,2));
    OBB{i}.v = v/norm(v);
    w = (corners{i}(:,6) - corners{i}(:,2));
    OBB{i}.w = w/norm(w);
    
    %%%% getting half size
    OBB{i}.halfU = norm(u)/2;
    OBB{i}.halfV = norm(v)/2;
    OBB{i}.halfW = norm(w)/2;
    
    %%%% getting centroid position of BB
    OBB{i}.pos = corners{i}(:,2) + OBB{i}.halfU*OBB{i}.u + OBB{i}.halfV*OBB{i}.v + OBB{i}.halfW*OBB{i}.w;
    
end
end