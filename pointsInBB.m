function[id] = pointsInBB(P, corners)
%pointsInBB returns mask for points in bounding box
%args:
%  P: point cloud
%  corners: of bounding box
%returns:
%  id: mask for points in P that are in bounding box
%
%   [3]
%   ^    [6]
%   |   /
% v |  / w
%   | /
%  [2] -----> [1]
%         u

u = (corners(:,1) - corners(:,2));
v = (corners(:,3) - corners(:,2));
w = (corners(:,6) - corners(:,2));

% u = cross((corners(:,2) - corners(:,3)),(corners(:,2) - corners(:,6)));
% v = cross((corners(:,2) - corners(:,1)),(corners(:,2) - corners(:,6)));
% w = cross((corners(:,2) - corners(:,1)),(corners(:,2) - corners(:,3)));

udotP1 = u'*corners(:,1);
udotP2 = u'*corners(:,2);
vdotP3 = v'*corners(:,3);
vdotP2 = v'*corners(:,2);
wdotP6 = w'*corners(:,6);
wdotP2 = w'*corners(:,2);

Pdotu = P*u;
Pdotv = P*v;
Pdotw = P*w;

idt1 = Pdotu >= udotP2 & Pdotu <= udotP1;
idt2 = Pdotv >= vdotP2 & Pdotv <= vdotP3;
idt3 = Pdotw >= wdotP2 & Pdotw <= wdotP6;


id = idt1&idt2&idt3;
% extract = P(id,:);   to extract points
end