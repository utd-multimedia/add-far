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



%%%%%%%%%% Loadin RGB detection results and mergin them
[C3, C4] = loadRGBDetectionResults();

config_file = 'config.json';
config = jsondecode(fileread(config_file));
paths = config.paths;

% options
% root_dir = 'D:\3DForensics\Datasets\KITTI_3D_ObjDet';
root_dir = paths.root_dir_create_Attacks;
data_set = 'training';



% get sub-directories
cam = 2; % 2 = left color camera
point_dir = fullfile(root_dir,[data_set '/velodyne']);
label_dir = fullfile(root_dir,[data_set '/label_' num2str(cam)]);
image_dir = fullfile(root_dir,[data_set '/image_' num2str(cam)]);
calib_dir = fullfile(root_dir,[data_set '/calib']);

% get sub-directories for creating dataset
%dataset_dir = 'D:\3DForensics\Datasets\KITTI_3D_ObjDet\AugmentedDataset';
dataset_dir = paths.dataset_dir;
point_dir1 = fullfile(dataset_dir,[data_set '/velodyne']);
label_dir1 = fullfile(dataset_dir,[data_set '/label_' num2str(cam)]);
image_dir1 = fullfile(dataset_dir,[data_set '/image_' num2str(cam)]);
calib_dir1 = fullfile(dataset_dir,[data_set '/calib']);


%%%%% this to extract forged for performing additive attacks
idx_Ex = 2527;
objects_Ex = readLabels(label_dir, idx_Ex);

[Tr_cam_to_velo_Ex, Tr_velo_to_cam_Ex, Tr_velo_to_leftI_Ex] = readCalibration(calib_dir,idx_Ex,cam);

%for bin files
fid = fopen([point_dir filesep sprintf('%06d.bin',idx_Ex)],'rb');
velo_Ex = fread(fid,[4 inf],'single')';
fclose(fid);

%%%% extract rgb images of the forged data
Im_Ex = imread([image_dir filesep sprintf('%06d.png',idx_Ex)]);
Im_Ex1 = Im_Ex(ceil(objects_Ex(1).y1):ceil(objects_Ex(1).y2),ceil(objects_Ex(1).x1):ceil(objects_Ex(1).x2),:);

%%%% 2d rgb detection results for forged frame idx_EX
idRGB = cell2mat(C4{1,1}) == idx_Ex;
C2{1,1} = C3{1,1}(idRGB);
C2{1,2} = C3{1,2}(idRGB);
C2{1,3} = C3{1,3}(idRGB);
C2{1,4} = C3{1,4}(idRGB);
C2{1,5} = C3{1,5}(idRGB);
C2{1,6} = C3{1,6}(idRGB);
C2{1,7} = C3{1,7}(idRGB);

%%%%%%%%%%% Selecting the first object for creating the forged data ... we
%%%%%%%%%%% are selecting the object that is exactly in front of the LiDAR
%%%%%%%%%%% vehicle    assumign d_safe = 37 meters
corners_3D_Ex{1} =  computeBox3D(objects_Ex(1));
corners_3DVelo_Ex = cornersCam2Velo(corners_3D_Ex, Tr_cam_to_velo_Ex);
objects_Ex_Velo = boxCenterCam2Velo(objects_Ex, Tr_cam_to_velo_Ex);
d_safe = 37;

framesNotAttacked = [];

for idx = 5001:7480
    % idx = 6;
    disp(sprintf('%s%d',' idx = ', idx));
    objects = readLabels(label_dir, idx);
    
    [Tr_cam_to_velo, Tr_velo_to_cam, Tr_velo_to_leftI] = readCalibration(calib_dir,idx,cam);
    
    %for bin files
    fid = fopen([point_dir filesep sprintf('%06d.bin',idx)],'rb');
    velo = fread(fid,[4 inf],'single')';
    fclose(fid);
    
    Im = imread([image_dir filesep sprintf('%06d.png',idx)]);
    
    
    
    
    
    % Im(objects_Ex(1).y1:objects_Ex(1).y2,objects_Ex(1).x1:objects_Ex(1).x2, :) = Im_Ex1;
    %%%%%%%%%%%%%% Extracting RGB Detection results for frame idx
    idRGB = cell2mat(C4{1,1}) == idx;
    C1{1,1} = C3{1,1}(idRGB);
    C1{1,2} = C3{1,2}(idRGB);
    C1{1,3} = C3{1,3}(idRGB);
    C1{1,4} = C3{1,4}(idRGB);
    C1{1,5} = C3{1,5}(idRGB);
    C1{1,6} = C3{1,6}(idRGB);
    C1{1,7} = C3{1,7}(idRGB);
    
    
    
    % C5{1,2} = C2{1,2}{1,1};
    % C5{1,2} = C2{1,2}(1);
    % C5{1,3} = C2{1,3}(1);
    % C5{1,4} = C2{1,4}(1);
    % C5{1,5} = C2{1,5}(1);
    % C5{1,6} = C2{1,6}(1);
    % C5{1,7} = C2{1,7}(1);
    
    
    %%% Select bounding boxes of objects that are close to the car with d_min <
    %%% Z < d_max and from class {'Car', 'Pedestrian', 'Cyclist'}, if
    %%% additional classes are used then the if statement must be changed
    
    selectedBB = [];
    corres2D = [];
    d_min = 7;
    d_max = 35;
    
    for ix = 1:size(objects,2)
        if((strcmp(objects(ix).type,'Car') || strcmp(objects(ix).type,'Cyclist') || strcmp(objects(ix).type,'Pedestrian')) &&  objects(ix).t(3) >= d_min && objects(ix).t(3) <= d_max)
            [minD, minIdx] = getCorrespondance2Dto3D(objects(ix), C1);
            if(minD < 1000)
                selectedBB = [selectedBB objects(ix)];
                corres2D = [corres2D minIdx];
            end
        end
    end
       
    % %% Extracting forged data
    % P = dlmread('E:\3DForensics\Datasets\KITTI\Kitti_txt_data\road\2011_09_26\2011_09_26_drive_0052_sync\velodyne_points\txt_points\33.txt');
    % idEx = P(:,1) > 5.2 & P(:,1) < 7.4 & P(:,2) > (-1.5) & P(:,2) < 0.9 & P(:,3) > (-1.65) & P(:,3) < (-0.09);
    % extract = P(idEx,:);
    
      
    %% proceed only if there is any object of interest within specified distance
    if(~isempty(selectedBB))
        
        %%%% initializing the attacked data as original
        P_Forged2 = velo;
        P_Forged4 = velo;
        P_Forged5 = velo;
        P_Forged6 = velo;
        
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
        
%         %%%%%   Draw original point cloud with the bounding box
%                 figure, pcshow(velo(:,1:3)); hold on,        
%                 for i = 1:size(corners_3DVelo,2)
%                     drawBox3D(corners_3DVelo{i}, face_idx);
%                 end
        
        %%%%%%%%%% computing risk factor for the forged data extracted for attack1
        [OBB_Ex] = getOBB(corners_3DVelo_Ex);
        [OBB] = getOBB(corners_3DVelo);
        
        %%% When we are inserting a forged object, we want to make sure it
        %%% is not colliding with existing objects
        collide = zeros(size(OBB));
        for ij = 1:size(OBB,2)
            collide(ij) = getCollision(OBB_Ex{1}, OBB{ij});
        end
        
        collideT = collide;
        
        transT = [1 0 0; -1 0 0; 0 1 0; 0 -1 0];
        ij1 = 1;
        while(sum(collideT > 0) && ij1 < 5)
            OBB_temp = OBB_Ex;
            transPos = transT(ij1,:)';
            ij1 = ij1 + 1;
            OBB_temp{1}.pos = OBB_temp{1}.pos + transPos;
            
            for ij = 1:size(OBB,2)
                collideT(ij) = getCollision(OBB_temp{1}, OBB{ij});
            end
        end
        
        if(sum(collideT > 0))
            framesNotAttacked = [framesNotAttacked; idx];
            disp('forged object is still colliding with existing object. Modify the transT');
            continue
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
            %             N_p{ix} =  nnz(id1);
            riskF{ix} = f_d{ix} * costheta{ix};
        end
                
        if(ij1 > 1)
            transPos = transT(ij1-1,:);
        else
            transPos = [0 0 0];
        end
        
        
        %%%% transofmring the corners to get updated 2d bounding box position
        corners_3DVelo_Ex1{1,1} = corners_3DVelo_Ex{1,1}+(transPos'.*ones(3,8));
        corners_leftI_Ex = cornersVelo2LeftI(corners_3DVelo_Ex1, Tr_velo_to_leftI_Ex, 1, size(Im, 2), size(Im,1));
        
        d = norm(objects_Ex_Velo(1).t + transPos);
        f_d_Ex = max(0, (d_safe - d)/d_safe);
        costheta_Ex = ((objects_Ex_Velo(1).t./d) * [1;0;0]);
        id_Ex = pointsInBB(velo_Ex(:,1:3), corners_3DVelo_Ex{1});
        %         N_Ex =  nnz(id_Ex);
        riskF_Ex = f_d_Ex * costheta_Ex;
        extract = velo_Ex(id_Ex,:);
        extract(:,1:3) = extract(:,1:3)+ transPos;
        
        %%%%%%%%%%% Additive attack
        P_Forged1 = [velo; extract];
%         figure, pcshow(P_Forged1(:,1:3));
        im_temp_Ex = imresize(Im_Ex1,[corners_leftI_Ex{1,1}(4)-corners_leftI_Ex{1,1}(2)+1 corners_leftI_Ex{1,1}(3)-corners_leftI_Ex{1,1}(1)+1],'bicubic');
        Im1 = Im;
        Im1(corners_leftI_Ex{1,1}(2): corners_leftI_Ex{1,1}(4), corners_leftI_Ex{1,1}(1): corners_leftI_Ex{1,1}(3),:) = im_temp_Ex;
%         figure, imshow(Im1);
        
        %%%% adjusting RGB Detection results
        C_1 = C1;
        N = size(C_1{1,1},1);
        C_1{1,1}{N+1,1} = C2{1,1}{1,1};
        C_1{1,2}(N+1,1) = C2{1,2}(1);
        C_1{1,3}(N+1,1) = C2{1,3}(1);
        C_1{1,4}(N+1,1) = C2{1,4}(1);
        C_1{1,5}(N+1,1) = C2{1,5}(1);
        C_1{1,6}(N+1,1) = C2{1,6}(1);
        C_1{1,7}(N+1,1) = C2{1,7}(1);
        
        %%%% copying files
        [a1_dir, a2_dir] = findAttackDir(riskF_Ex, 'Attack1');
        copyfilesV_new(a1_dir, calib_dir, image_dir, label_dir, idx, Im1);
        %     copyfilesV_attack1(a1_dir, calib_dir, label_dir, idx, Im);
        writeRGBDetctResult(C1, C_1, a1_dir, a2_dir);
        writePC2Bin(P_Forged1, a1_dir);
        
        %%%%%% adding label for the forged object
        objects_F1 = objects;
        objects_F1(size(objects,2)+1) = objects_Ex(1);
        
        writeLabels(objects_Ex, label_dir1, idx_Ex);
        
        for i = 1:size(selectedBBDVelo,2)
            
            %%%%% This modification is to make sure every object is treated
            %%%%% separatly for creating attacks
            P_Forged2 = velo;
            P_Forged4 = velo;
            P_Forged5 = velo;
            P_Forged6 = velo;
            
            
            id1 = pointsInBB(P_Forged2(:,1:3), corners_3DVelo{i});
            
            %%%%%%%% subtractive forgery
            
            avgX = mean(P_Forged2(id1,1));
            avgY = mean(P_Forged2(id1,2));
            P_Forged2(id1,:) = [];
            Im2 = Im;
            [selectedBBDVelo_valid, selectedBBDVelo_valid1] = checkValidBB(selectedBBDVelo(i), size(Im, 2), size(Im,1));
            im_temp = Im2(selectedBBDVelo_valid.y1:selectedBBDVelo_valid.y2,selectedBBDVelo_valid.x1:selectedBBDVelo_valid.x2,:);
            Im2(selectedBBDVelo_valid1.y1:selectedBBDVelo_valid1.y2,selectedBBDVelo_valid1.x1:selectedBBDVelo_valid1.x2,:) = im_temp;
%             figure, imshow(Im2);
%             figure, pcshow(P_Forged2(:,1:3));
            %%%% adjusting RGB Detection results
            C_2 = C1;
            C_2{1}(corres2D(i),:) = [];
            C_2{2}(corres2D(i),:) = [];
            C_2{3}(corres2D(i),:) = [];
            C_2{4}(corres2D(i),:) = [];
            C_2{5}(corres2D(i),:) = [];
            C_2{6}(corres2D(i),:) = [];
            C_2{7}(corres2D(i),:) = [];
            
            
            %%%% copying files
            [a1_dir, a2_dir] = findAttackDir(riskF{i} * 1.0 , 'Attack2');
            copyfilesV_new(a1_dir, calib_dir, image_dir, label_dir, idx, Im2);
            writeRGBDetctResult(C1, C_2, a1_dir, a2_dir);
            writePC2Bin(P_Forged2, a1_dir);
            
            %%%%%%%%%% combined attack: deletion and addition at same place
            %%%%%%%%%% REPLACEMENT
            id1 = pointsInBB(P_Forged4(:,1:3), corners_3DVelo{i});
            P_Forged4(id1,:) = [];
            avgXExt = mean(extract(:,1));
            avgYExt = mean(extract(:,2));
            extract1 = extract;
            extract1(:,1) = extract(:,1) - avgXExt + avgX;
            extract1(:,2) = extract(:,2) - avgYExt + avgY;
            
            
            P_Forged4 = [P_Forged4; extract1];
            
            Im4 = Im;
            im_temp = Im4(selectedBBDVelo_valid.y1:selectedBBDVelo_valid.y2,selectedBBDVelo_valid.x1:selectedBBDVelo_valid.x2,:);
            Im4(selectedBBDVelo_valid1.y1:selectedBBDVelo_valid1.y2,selectedBBDVelo_valid1.x1:selectedBBDVelo_valid1.x2,:) = im_temp;
            
            %%%% transofmring the corners to get updated 2d bounding box position
            transPos1 = [(-avgXExt+avgX) (- avgYExt + avgY) 0];
            corners_3DVelo_Ex2{1,1} = corners_3DVelo_Ex1{1,1}+(transPos1'.*ones(3,8));
            corners_leftI_Ex2 = cornersVelo2LeftI(corners_3DVelo_Ex2, Tr_velo_to_leftI_Ex, 1, size(Im, 2), size(Im,1));
            im_temp_Ex1 = imresize(Im_Ex1,[corners_leftI_Ex2{1,1}(4)-corners_leftI_Ex2{1,1}(2)+1 corners_leftI_Ex2{1,1}(3)-corners_leftI_Ex2{1,1}(1)+1],'bicubic');
            
            Im4(corners_leftI_Ex2{1,1}(2): corners_leftI_Ex2{1,1}(4), corners_leftI_Ex2{1,1}(1): corners_leftI_Ex2{1,1}(3),:) = im_temp_Ex1;
%             figure, imshow(Im4);
%             figure, pcshow(P_Forged4(:,1:3));
            %%%% adjusting RGB Detection results
            C_4 = C1;
            C_4{1}{corres2D(i),:} = C2{1,1}{1,1};
            C_4{2}(corres2D(i),:) = C2{1,2}(1);
            C_4{3}(corres2D(i),:) = C2{1,3}(1);
            C_4{4}(corres2D(i),:) = C2{1,4}(1);
            C_4{5}(corres2D(i),:) = C2{1,5}(1);
            C_4{6}(corres2D(i),:) = C2{1,6}(1);
            C_4{7}(corres2D(i),:) = C2{1,7}(1);
            
            %%%% copying files
            [a1_dir, a2_dir] = findAttackDir(riskF{i} * 0.3 , 'Attack4');
            copyfilesV_new(a1_dir, calib_dir, image_dir, label_dir, idx, Im4);
            writeRGBDetctResult(C1, C_4, a1_dir, a2_dir);
            writePC2Bin(P_Forged4, a1_dir);
            
            %%%%%%%%%%%%%%%%%%%%%%%%% translation attack
            id1 = pointsInBB(P_Forged5(:,1:3), corners_3DVelo{i});
            P_Forged5(id1,1) = P_Forged5(id1,1) + 3;
            
            
            
            Im5 = Im;
            % extracting the neighboring region to fill the hole
            im_temp = Im5(selectedBBDVelo_valid.y1:selectedBBDVelo_valid.y2,selectedBBDVelo_valid.x1:selectedBBDVelo_valid.x2,:);
            % extracting the region corresponding to the object of interest in
            % RGB image
            im_temp_1 = Im5(selectedBBDVelo_valid1.y1:selectedBBDVelo_valid1.y2,selectedBBDVelo_valid1.x1:selectedBBDVelo_valid1.x2,:);
            %% replacing the region of object of interest with the neighboring region
            Im5(selectedBBDVelo_valid1.y1:selectedBBDVelo_valid1.y2,selectedBBDVelo_valid1.x1:selectedBBDVelo_valid1.x2,:) = im_temp;
            
            transPos1 = [3 0 0];
            % translate corners
            corners_3DVelo1{1,i} = corners_3DVelo{1,i}+(transPos1'.*ones(3,8));
            % convert to corresponding corners in 2d BB
            corners_leftI = cornersVelo2LeftI(corners_3DVelo1, Tr_velo_to_leftI_Ex, i, size(Im, 2), size(Im,1));
            % resize the region of object of interest to modified 2d BB size
            im_temp = imresize(im_temp_1,[corners_leftI{1,1}(4)-corners_leftI{1,1}(2)+1 corners_leftI{1,1}(3)-corners_leftI{1,1}(1)+1],'bicubic');
            
            Im5(corners_leftI{1,1}(2): corners_leftI{1,1}(4), corners_leftI{1,1}(1): corners_leftI{1,1}(3),:) = im_temp;
%             figure, imshow(Im5);
%             figure, pcshow(P_Forged5(:,1:3));
            %%%% adjusting RGB Detection results
            C_5 = C1;
            C_5{4}(corres2D(i),:) = corners_leftI{1,1}(1);
            C_5{5}(corres2D(i),:) = corners_leftI{1,1}(2);
            C_5{6}(corres2D(i),:) = corners_leftI{1,1}(3);
            C_5{7}(corres2D(i),:) = corners_leftI{1,1}(4);
            
            %%%% copying files
            [a1_dir, a2_dir] = findAttackDir(riskF{i} * 0.95 , 'Attack5');
            copyfilesV_new(a1_dir, calib_dir, image_dir, label_dir, idx, Im5);
            writeRGBDetctResult(C1, C_5, a1_dir, a2_dir);
            writePC2Bin(P_Forged5, a1_dir);
            
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
            
            
            Im6 = Im;
            % extracting the neighboring region to fill the hole
            im_temp = Im6(selectedBBDVelo_valid.y1:selectedBBDVelo_valid.y2,selectedBBDVelo_valid.x1:selectedBBDVelo_valid.x2,:);
            % extracting the region corresponding to the object of interest in
            % RGB image
            im_temp_1 = Im6(selectedBBDVelo_valid1.y1:selectedBBDVelo_valid1.y2,selectedBBDVelo_valid1.x1:selectedBBDVelo_valid1.x2,:);
            %% replacing the region of object of interest with the neighboring region
            Im6(selectedBBDVelo_valid1.y1:selectedBBDVelo_valid1.y2,selectedBBDVelo_valid1.x1:selectedBBDVelo_valid1.x2,:) = im_temp;
            
            transPos1 = [avgX avgY avgZ];
            % translate corners
            corners_3DVelo1{1,i} = corners_3DVelo{1,i}-(transPos1'.*ones(3,8));
            corners_3DVelo1{1,i} = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1]*corners_3DVelo1{1,i};
            corners_3DVelo1{1,i} = corners_3DVelo1{1,i}+(transPos1'.*ones(3,8));
            transPos1 = [0 -2 0];
            corners_3DVelo1{1,i} = corners_3DVelo1{1,i}+(transPos1'.*ones(3,8));
            % convert to corresponding corners in 2d BB
            corners_leftI = cornersVelo2LeftI(corners_3DVelo1, Tr_velo_to_leftI_Ex, i, size(Im, 2), size(Im,1));
            % resize the region of object of interest to modified 2d BB size
            im_temp = imresize(im_temp_1,[corners_leftI{1,1}(4)-corners_leftI{1,1}(2)+1 corners_leftI{1,1}(3)-corners_leftI{1,1}(1)+1],'bicubic');
            
            Im6(corners_leftI{1,1}(2): corners_leftI{1,1}(4), corners_leftI{1,1}(1): corners_leftI{1,1}(3),:) = im_temp;
%             figure, imshow(Im6);
%             figure, pcshow(P_Forged6(:,1:3));
            %%%% adjusting RGB Detection results
            C_6 = C1;
            C_6{4}(corres2D(i),:) = corners_leftI{1,1}(1);
            C_6{5}(corres2D(i),:) = corners_leftI{1,1}(2);
            C_6{6}(corres2D(i),:) = corners_leftI{1,1}(3);
            C_6{7}(corres2D(i),:) = corners_leftI{1,1}(4);
            
            
            %%%% copying files
            [a1_dir, a2_dir] = findAttackDir(riskF{i} * 0.5 , 'Attack6');
            copyfilesV_new(a1_dir, calib_dir, image_dir, label_dir, idx, Im6);
            writeRGBDetctResult(C1, C_6, a1_dir, a2_dir);
            writePC2Bin(P_Forged6, a1_dir);
            
            %%%%%%%%%% combined attack : addition and subtraction
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            Im3 = Im;
            im_temp = Im3(selectedBBDVelo_valid.y1:selectedBBDVelo_valid.y2,selectedBBDVelo_valid.x1:selectedBBDVelo_valid.x2,:);
            Im3(selectedBBDVelo_valid1.y1:selectedBBDVelo_valid1.y2,selectedBBDVelo_valid1.x1:selectedBBDVelo_valid1.x2,:) = im_temp;
            Im3(corners_leftI_Ex{1,1}(2): corners_leftI_Ex{1,1}(4), corners_leftI_Ex{1,1}(1): corners_leftI_Ex{1,1}(3),:) = im_temp_Ex;
%             figure, imshow(Im3);
%             figure, pcshow(P_Forged3(:,1:3));
            %%%% adjusting RGB Detection results
            C_3 = C1;
            C_3{1}(corres2D(i),:) = [];
            C_3{2}(corres2D(i),:) = [];
            C_3{3}(corres2D(i),:) = [];
            C_3{4}(corres2D(i),:) = [];
            C_3{5}(corres2D(i),:) = [];
            C_3{6}(corres2D(i),:) = [];
            C_3{7}(corres2D(i),:) = [];
            if(isempty(C_3{1,1}))
                N = 0;
            else
                N = size(C_3{1,1},1);
            end
            C_3{1,1}{N+1,1} = C2{1,1}{1,1};
            C_3{1,2}(N+1,1) = C2{1,2}(1);
            C_3{1,3}(N+1,1) = C2{1,3}(1);
            C_3{1,4}(N+1,1) = C2{1,4}(1);
            C_3{1,5}(N+1,1) = C2{1,5}(1);
            C_3{1,6}(N+1,1) = C2{1,6}(1);
            C_3{1,7}(N+1,1) = C2{1,7}(1);
            
            %%%% copying files
            [a1_dir, a2_dir] = findAttackDir(riskF{i} * 0.95 , 'Attack3');
            copyfilesV_new(a1_dir, calib_dir, image_dir, label_dir, idx, Im3);
            writeRGBDetctResult(C1, C_3, a1_dir, a2_dir);
            writePC2Bin(P_Forged3, a1_dir);
            
            %%% Display all attacked point clouds
            %         figure, pcshow(P_Forged2(:,1:3));
            %         figure, pcshow(P_Forged3(:,1:3));
            %         figure, pcshow(P_Forged4(:,1:3));
            %         figure, pcshow(P_Forged5(:,1:3));
            %         figure, pcshow(P_Forged6(:,1:3));
        end
        
        
        
        %%% Display all attacked point clouds
        %         figure, pcshow(P_Forged1(:,1:3));
        %         figure, pcshow(P_Forged2(:,1:3));
        %         figure, pcshow(P_Forged3(:,1:3));
        %         figure, pcshow(P_Forged4(:,1:3));
        %         figure, pcshow(P_Forged5(:,1:3));
        %         figure, pcshow(P_Forged6(:,1:3));
    end
    %     close all;
end

