function corners_leftI = cornersVelo2LeftI(corners_3DVelo, Tr_velo_to_leftI, i, w, h)
% cornersVelo2LeftI converts to corresponding corners in 2d BB
% args:
% corners_3DVelo 8 corners of the Bounding Box
% Tr_velo_to_leftI transformation matrix
% i bounding box index
% w width
% h height


% Number of objects detected
% Nobj = size(corners_3DVelo,2);
% corners_leftI = corners_3DVelo;
% for i = 1:Nobj  
%     for j=1:8
%         temp = Tr_velo_to_leftI * [corners_3DVelo{i}(:,j); 1];
%         temp2(:,j) = temp(1:3)./temp(3);
%     end
%     corners_leftI{i} = round([min(temp2(1,:)) min(temp2(2,:)) max(temp2(1,:)) max(temp2(2,:))]);
% end




    for j=1:8
        temp = Tr_velo_to_leftI * [corners_3DVelo{i}(:,j); 1];
        temp2(:,j) = temp(1:3)./temp(3);
    end
    
    minX = min(w, max(1, min(temp2(1,:))));
    maxX = max(1, min(w, max(temp2(1,:))));
    minY = min(h, max(1, min(temp2(2,:))));
    maxY = max(1, min(h, max(temp2(2,:))));
    %corners_leftI{1} = round([min(temp2(1,:)) min(temp2(2,:)) max(temp2(1,:)) max(temp2(2,:))]);
    corners_leftI{1} = round([minX minY maxX maxY]);

end