function[minD, minIdx] = getCorrespondance2Dto3D(objects, C1)
b = [objects(1).x1 objects(1).y1 objects(1).x2 objects(1).y2];

dist = zeros(1,size(C1{2},1));
for j = 1:size(C1{2},1)
    a = [C1{4}(j) C1{5}(j) C1{6}(j) C1{7}(j)];
    c = double(a)-b;
    dist(j) = sum(c.*c);
end
[minD, minIdx] = min(dist);

end