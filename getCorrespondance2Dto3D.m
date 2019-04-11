function[minD, minIdx] = getCorrespondance2Dto3D(object, C1)
%getCorrespondance2Dto3D returns closest 2D bounding box to given object
%args:
%  object: details of object, including 2D bounding box
%  C1: cell array of 2D bounding boxes
%returns:
%  minD: disparity between closest 2D bounding box and object
%  minIdx: index of closest 2D bounding box in C1

b = [object(1).x1 object(1).y1 object(1).x2 object(1).y2];

dist = zeros(1,size(C1{2},1));
for j = 1:size(C1{2},1)
    a = [C1{4}(j) C1{5}(j) C1{6}(j) C1{7}(j)];
    c = double(a)-b;
    dist(j) = sum(c.*c);
end
[minD, minIdx] = min(dist);

end