function[selectedBBDVelo_valid, selectedBBDVelo_valid1] = checkValidBB(selectedBBDVelo, w, h)
% checkValidBB checks if 2d bounding box related to the object of interest
% is valid (satisfying the image size constraints). If not, it is adjusted
% to satisfy the constraints ( such as min_=x > 0, max_x < image.width,
% min_y > 0 and max_y < image.height). Modified bounding box is saved as
% ?selectedBBDVelo_valid1?.
% Next, this bounding box region must be replaced with another region from
% the same image to conceal the object of interest. The region that must be
% copied is stored in ?selectedBBDVelo_valid?.
% In fig: subtractiveAttackExplanationImage.png:
% Red box is ?selectedBBDVelo_valid1?
% Green box is ?selectedBBDVelo_valid?.
%
%
% args:
% selectedBBDVelo 2D bounding box of object of interest
% w number of columns
% h number of rows
% returns:
% selectedBBDVelo_valid source bounding box in image
% selectedBBDVelo_valid1 destination bounding box in image

y1 = ceil(selectedBBDVelo.y1);
y2= ceil(selectedBBDVelo.y2);
x1 = ceil(selectedBBDVelo.x1);
x2 = ceil(selectedBBDVelo.x2);

selectedBBDVelo_valid1.y1 = y1;
selectedBBDVelo_valid1.y2 = y2;
selectedBBDVelo_valid1.x1 = x1;
selectedBBDVelo_valid1.x2 = x2;

if(y1 < 1)
    selectedBBDVelo_valid1.y1 = 1;
    selectedBBDVelo_valid1.y2 = y2+(1 - y1);
end
if(x1 < 1)
    selectedBBDVelo_valid1.x1 = 1;
    selectedBBDVelo_valid1.x2 = x2+(1 - x1);
end

if(y2 > h)
    selectedBBDVelo_valid1.y2 = h;
    selectedBBDVelo_valid1.y1 = y1 - (y2 - h);
end
if(x2 > w)
    selectedBBDVelo_valid1.x2 = w;
    selectedBBDVelo_valid1.x2 = x1 - (x2 - w);
end

y1 = selectedBBDVelo_valid1.y1;
y2 = selectedBBDVelo_valid1.y2;
x1 = selectedBBDVelo_valid1.x1;
x2 = selectedBBDVelo_valid1.x2;

if((2*x1-x2) > 0)
    selectedBBDVelo_valid.y1 = y1;
    selectedBBDVelo_valid.y2 = y2;
    selectedBBDVelo_valid.x1 = 2*x1-x2;
    selectedBBDVelo_valid.x2 = x1;
elseif((2*x2-x1) < w)
    selectedBBDVelo_valid.y1 = y1;
    selectedBBDVelo_valid.y2 = y2;
    selectedBBDVelo_valid.x1 = x2;
    selectedBBDVelo_valid.x2 = 2*x2 - x1;
elseif((2*y1-y2) > 0)
    selectedBBDVelo_valid.y1 = 2*y1-y2;
    selectedBBDVelo_valid.y2 = y1;
    selectedBBDVelo_valid.x1 = x1;
    selectedBBDVelo_valid.x2 = x2;
elseif((2*y2-y1) < h)
    selectedBBDVelo_valid.y1 = y2;
    selectedBBDVelo_valid.y2 = 2*y2-y1;
    selectedBBDVelo_valid.x1 = x1;
    selectedBBDVelo_valid.x2 = x2;
end



end