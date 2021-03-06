function corners_3DVelo = cornersCam2Velo(corners_3D, Tr_cam_to_velo)
% cornersCam2Velo transforms object to velodyne coordinates
% args:
% corners_3D 8 corners of the Bounding Box
% Tr_cam_to_velo transformation matrix



% Number of objects detected
Nobj = size(corners_3D,2);
corners_3DVelo = corners_3D;
for i = 1:Nobj  
    for j=1:8
        temp = Tr_cam_to_velo * [corners_3D{i}(:,j); 1];
        corners_3DVelo{i}(:,j) = temp(1:3);
    end
end

end