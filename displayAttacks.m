% Author: Kanchan Bahirat
% Code to display original and attacked data 

% clear and close everything
clear all; close all;
disp('======= Display attacked dataset =======');

config_file = 'config.json';
config = jsondecode(fileread(config_file));
paths = config.paths;

% options
root_dir = paths.root_dir_create_Attacks;
data_set = 'training';

% get sub-directories
cam = 2; % 2 = left color camera
point_dir = fullfile(root_dir,[data_set '/velodyne']);
image_dir = fullfile(root_dir,[data_set '/image_' num2str(cam)]);

% get sub-directories for creating dataset
dataset_dir = paths.dataset_dir_E5;
point_dir1 = fullfile(dataset_dir,['/velodyne']);
% image_dir1 = fullfile(dataset_dir,['/image_' num2str(cam)]);
image_dir1 = fullfile(dataset_dir,['/image_' num2str(cam) '_mod']);

idx_Ex = 19;
%for bin files
fid = fopen([point_dir filesep sprintf('%06d.bin',idx_Ex)],'rb');
velo_Ex = fread(fid,[4 inf],'single')';
fclose(fid);

%%%% extract rgb images of the forged data
Im_Ex = imread([image_dir filesep sprintf('%06d.png',idx_Ex)]);


idx = 4;

%for bin files
fid = fopen([point_dir1 filesep sprintf('%06d.bin',idx)],'rb');
velo = fread(fid,[4 inf],'single')';
fclose(fid);

Im = imread([image_dir1 filesep sprintf('%06d.png',idx)]);


 figure, pcshow(velo_Ex(:,1:3));
 figure, pcshow(velo(:,1:3));

 figure, imshow(Im_Ex);
 figure, imshow(Im);




    
    
    