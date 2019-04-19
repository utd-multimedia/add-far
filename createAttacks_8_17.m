% Author: Kanchan Bahirat
% Code to automatically create attacks on 3D point cloud data from KITTI
% Dataset where 3D bounding box details are available
% This code creates following different types of attackas:
%    1. Additive,
%	 2. Subtractive,
%	 3. Additive and Subtractive,
%	 4. Replacement,
%	 5. Translation,
%	 6. Rotation

% clear and close everything
clear all; close all;
disp('======= Create automated forged dataset =======');

% options
config_file = 'config.json';
config = jsondecode(fileread(config_file));
paths = config.paths;
root_dir = paths.root_dir;
data_set = 'training';

% get sub-directories
cam = 2; % 2 = left color camera
point_dir = fullfile(root_dir,[data_set filesep 'velodyne']);
label_dir = fullfile(root_dir,[data_set filesep 'label_' num2str(cam)]);
calib_dir = fullfile(root_dir,[data_set filesep 'calib']);

% N = 7481;   % No. of original pointclouds

% for idx = 1: N
%
%
% end

idx = 38;
objects = readLabels(label_dir, idx);

Tr_cam_to_velo = readCalibration(calib_dir,idx,cam);

%for bin files

fid = fopen([point_dir filesep sprintf('%06d.bin', idx)],'rb');
velo = fread(fid,[4 inf],'single')';
fclose(fid);


%%%%% this to extract forged for performign additive atatcks
idx_Ex = 2527;
objects_Ex = readLabels(label_dir, idx_Ex);

Tr_cam_to_velo_Ex = readCalibration(calib_dir,idx_Ex,cam);

%for bin files
fid = fopen([point_dir filesep sprintf('%06d.bin', idx_Ex)],'rb');
velo_Ex = fread(fid,[4 inf],'single')';
fclose(fid);


%%% Select bounding boxes of objects that are close to the car with d_min <
%%% Z < d_max and from class {'Car', 'Pedestrian', 'Cyclist'}

selectedBB = [];
d_min = 3;
d_max = 35;

for ix = 1:size(objects,2)
    if(~strcmp(objects(ix).type,'DontCare') &&  objects(ix).t(3) >= d_min && objects(ix).t(3) <= d_max)
        selectedBB = [selectedBB objects(ix)];
    end
end


%%%%%%%%%%% Selecting the first object for creating the forged data ... we
%%%%%%%%%%% are selecting the object that is exactly in front of the LiDAR
%%%%%%%%%%% vehicle    assumign d_safe = 37 meters
corners_3D_Ex{1} =  computeBox3D(objects_Ex(1));
corners_3DVelo_Ex = cornersCam2Velo(corners_3D_Ex, Tr_cam_to_velo_Ex);
objects_Ex_Velo = boxCenterCam2Velo(objects_Ex, Tr_cam_to_velo_Ex);
d_safe = 37;


transPos = [0 0 0];
d = norm(objects_Ex_Velo(1).t + transPos);
f_d_Ex = max(0, (d_safe - d)/d_safe);
costheta_Ex = ((objects_Ex_Velo(1).t./d) * [1;0;0]);
id_Ex = pointsInBB(velo_Ex(:,1:3), corners_3DVelo_Ex{1});
N_Ex =  nnz(id_Ex);
riskF_Ex = f_d_Ex * costheta_Ex;
extract = velo_Ex(id_Ex,:);
extract(:,1:3) = extract(:,1:3)+ transPos;

% %% Extracting forged data
% text_file = paths.forged_data_text_file;
% P = dlmread(text_file);
% idEx = P(:,1) > 5.2 & P(:,1) < 7.4 & P(:,2) > (-1.5) & P(:,2) < 0.9 & P(:,3) > (-1.65) & P(:,3) < (-0.09);
% extract = P(idEx,:);


P_Forged2 = velo;
P_Forged4 = velo;
P_Forged5 = velo;
P_Forged6 = velo;

%% proceed only if there is any object of interest within specified distance
if(~isempty(selectedBB))
    %%% create 8 corners of selected bounding boxes
    for ix = 1:size(selectedBB,2)
        corners_3D{ix} = computeBox3D(selectedBB(ix));
    end
    
    % index for 3D bounding box faces
    face_idx = [ 1,2,6,5   % front face
        2,3,7,6   % left face
        3,4,8,7   % back face
        4,1,5,8]; % right face
    
    corners_3DVelo = cornersCam2Velo(corners_3D, Tr_cam_to_velo);
    
    
    figure, pcshow(velo(:,1:3)); hold on,
    
    for i = 1:size(corners_3DVelo,2)
        drawBox3D(corners_3DVelo{i}, face_idx);
    end
    
    
%     %%%%%%% risk factor copmputation for each bounding box
%     %%%%% computing d, N and theta assumign d_safe = 37 meters
    
    cornersSafe = [5 5 37 37 5 5 37 37; 10 -10 -10 10 10 -10 -10 10; -1.5 -1.5 -1.5 -1.5 2 2 2 2];
    id1 = pointsInBB(velo(:,1:3), cornersSafe);
    nTotal = nnz(id1);
    selectedBBDVelo = boxCenterCam2Velo(selectedBB, Tr_cam_to_velo);
    for ix = 1:size(selectedBB,2)
       d = norm(selectedBBDVelo(ix).t);
       f_d{ix} = max(0, (d_safe - d)/d_safe);
       costheta{ix} = ((selectedBBDVelo(ix).t./d) * [1;0;0]);
       id1 = pointsInBB(velo(:,1:3), corners_3DVelo{ix});
       %n = nnz(id1);
       N{ix} =  nnz(id1);
       riskF{ix} = f_d{ix} * costheta{ix};
    end
    
    %%%%%%%%%%% Additive attack
    P_Forged1 = [velo; extract];
    figure, pcshow(P_Forged1(:,1:3));
    
   
    
    for i = 1:size(corners_3DVelo,2)

       id1 = pointsInBB(P_Forged2(:,1:3), corners_3DVelo{i});
        %%%%%%%% subtractive forgery
        
        avgX = mean(P_Forged2(id1,1));
        avgY = mean(P_Forged2(id1,2));
        P_Forged2(id1,:) = [];
        
        
        %%%%%%%%%% combined attack: deletion and addition at same place
        id1 = pointsInBB(P_Forged4(:,1:3), corners_3DVelo{i});
        P_Forged4(id1,:) = [];
        avgXExt = mean(extract(:,1));
        avgYExt = mean(extract(:,2));
        extract1 = extract;
        extract1(:,1) = extract(:,1) - avgXExt + avgX;
        extract1(:,2) = extract(:,2) - avgYExt + avgY;
        
        
        P_Forged4 = [P_Forged4; extract1];
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%% translation attack
        id1 = pointsInBB(P_Forged5(:,1:3), corners_3DVelo{i});
        P_Forged5(id1,1) = P_Forged5(id1,1) + 3;
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Rotation attack
        
        
        % computing the centroid of the region of interest
        avgX = mean(P_Forged6(id1,1));
        avgY = mean(P_Forged6(id1,2));
        avgZ = mean(P_Forged6(id1,3));
        
        Ptemp = P_Forged6;
        x = Ptemp(id1,1) - avgX;
        y = Ptemp(id1,2) - avgY;
        z = Ptemp(id1,3) - avgZ;
        
        
        theta = -10*pi/180;
        X = x*cos(theta) - y*sin(theta);
        Y = x*sin(theta) + y*cos(theta);
        Z = z;
        
        P_Forged6(id1, 1) = X + avgX;
        P_Forged6(id1, 2) = Y + avgY;
        P_Forged6(id1, 3) = Z + avgZ;
        
        P_Forged6(id1, 2) = P_Forged6(id1, 2) + 2;
        
    end

    %%%%%%%%%% combined attack : addition and subtraction
    P_Forged3 = [P_Forged2; extract];
    
    %%% Display all attacked point clouds
    figure, pcshow(P_Forged2(:,1:3));
    figure, pcshow(P_Forged3(:,1:3));
    figure, pcshow(P_Forged4(:,1:3));
    figure, pcshow(P_Forged5(:,1:3));
    figure, pcshow(P_Forged6(:,1:3));

end

