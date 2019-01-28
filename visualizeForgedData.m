function[] = visualizeForgedData()

dirName = 'D:\3DForensics\Datasets\KITTI_3D_ObjDet\AugmentedDataset\Easy\Attack1\velodyne';

N = 0;

figure,
for idx = 0:N
    %for bin files
    fid = fopen(sprintf('%s\\%06d.bin',dirName,idx),'rb');
    pc = fread(fid,[4 inf],'single')';
    fclose(fid);
    pcshow(pc(:,1:3));
    fprintf('Program paused. Press enter to continue.\n');
    pause;
end


end