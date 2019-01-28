% Author: Kanchan Bahirat
% Code to display original and attacked data 

% clear and close everything
clear all; close all;
disp('======= Display attacked dataset =======');


% options
root_dir = 'D:\3DForensics\Datasets\KITTI_3D_ObjDet';
data_set = 'training';

% get sub-directories
cam = 2; % 2 = left color camera
point_dir = fullfile(root_dir,[data_set '/velodyne']);
image_dir = fullfile(root_dir,[data_set '/image_' num2str(cam)]);

% get sub-directories for creating dataset
dataset_dir = 'D:\3DForensics\Datasets\KITTI_3D_ObjDet\AugmentedDataset\Easy\Attack5';
point_dir1 = fullfile(dataset_dir,['/velodyne']);
% image_dir1 = fullfile(dataset_dir,['/image_' num2str(cam)]);
image_dir1 = fullfile(dataset_dir,['/image_' num2str(cam) '_mod']);

idx_Ex = 19;
%for bin files
fid = fopen(sprintf('%s/%06d.bin',point_dir,idx_Ex),'rb');
velo_Ex = fread(fid,[4 inf],'single')';
fclose(fid);

%%%% extract rgb images of the forged data
Im_Ex = imread(sprintf('%s/%06d.png',image_dir,idx_Ex));


idx = 4;

%for bin files
fid = fopen(sprintf('%s/%06d.bin',point_dir1,idx),'rb');
velo = fread(fid,[4 inf],'single')';
fclose(fid);

Im = imread(sprintf('%s/%06d.png',image_dir1,idx));


 figure, pcshow(velo_Ex(:,1:3));
 figure, pcshow(velo(:,1:3));

 figure, imshow(Im_Ex);
 figure, imshow(Im);




    
    
    