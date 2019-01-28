function selectedBBDVelo = boxCenterCam2Velo(selectedBB, Tr_cam_to_velo)

% Number of objects detected
Nobj = size(selectedBB,2);
selectedBBDVelo = selectedBB;
for i = 1:Nobj  
    for j=1:8
        temp = Tr_cam_to_velo * [selectedBB(i).t'; 1];
        selectedBBDVelo(i).t = temp(1:3)';
    end
end

end