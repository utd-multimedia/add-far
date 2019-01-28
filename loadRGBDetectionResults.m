function[C3, C4] = loadRGBDetectionResults()

%%%%%%%%%% loading rgb_detection results

% parse input file
fid = fopen('D:\3DForensics\Datasets\KITTI_3D_ObjDet\rgb_detections\rgb_detection_train.txt','r');
C1   = textscan(fid,'%s %d %f %d %d %d %d','delimiter', ' ');
fclose(fid);

fid = fopen('D:\3DForensics\Datasets\KITTI_3D_ObjDet\rgb_detections\rgb_detection_val.txt','r');
C   = textscan(fid,'%s %d %f %d %d %d %d','delimiter', ' ');
fclose(fid);

%%%% merging both train and val dataset
C2{1,1} = [C1{1,1}; C{1,1}];
C2{1,2} = [C1{1,2}; C{1,2}];
C2{1,3} = [C1{1,3}; C{1,3}];
C2{1,4} = [C1{1,4}; C{1,4}];
C2{1,5} = [C1{1,5}; C{1,5}];
C2{1,6} = [C1{1,6}; C{1,6}];
C2{1,7} = [C1{1,7}; C{1,7}];

%%%% sort based on file index
[res, resID] = sort(C2{1,1});

%%%% arrange data based on sorted indices
C3{1,1} = res;
C3{1,2} = C2{1,2}(resID);
C3{1,3} = C2{1,3}(resID);
C3{1,4} = C2{1,4}(resID);
C3{1,5} = C2{1,5}(resID);
C3{1,6} = C2{1,6}(resID);
C3{1,7} = C2{1,7}(resID);


for i = 1:size(res,1)
Csp1 = strsplit(C3{1,1}{i,1}, '/');
Csp2 = strsplit(Csp1{6},'.');
C4{1,1}{i,1} = str2double(Csp2{1});     %%% C4 will give indices for certain xxx.png
end


end


