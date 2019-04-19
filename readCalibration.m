function [FinalTr_cam_to_velo, FinalTr_velo_to_Cam ,FinalTr_vel_to_leftI] = readCalibration(calib_dir,img_idx,cam)
%readCalibration returns transformation matrices based on calibration data
%args:
%  calib_dir: directory containing calibration files
%  img_idx: file number
%returns:
%  FinalTr_cam_to_vel: camera to velodyne transformation matrix
%  FinalTr_velo_to_Cam: velodyne to camera transformation matrix
%  FinalTr_vel_to_leftI: 3D point to 2D pixel coordinate in stereo left image transformation matrix

  % load R_rect and velo_to_cam transformation matrix
  P = dlmread([calib_dir filesep sprintf('%06d.txt', img_idx)],' ',0,1);
  
  
  %%% Projection matrix for left RGB image
  P2 = P(cam+1,:);
  P2 = reshape(P2, [4 3])';
  
  %%% loading R_rect
  R = P(cam+3,:);  
  R = reshape(R(1:9) ,[3,3])';
  R_rect = eye(4);
  R_rect(1:3,1:3) = R;
  
  %%% loading velo_to_cam
  Tr_velo_to_cam = P(cam+4,:);
  Tr_velo_to_cam = reshape(Tr_velo_to_cam ,[4,3])';
  Tr_velo_to_cam = [Tr_velo_to_cam; 0 0 0 1];
  
  FinalTr_velo_to_Cam = R_rect * Tr_velo_to_cam;
  
  FinalTr_vel_to_leftI = P2 * R_rect * Tr_velo_to_cam;
  
  % computing transform from camera to velo
  FinalTr_cam_to_velo = pinv(FinalTr_velo_to_Cam);
  
end
