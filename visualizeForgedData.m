function[] = visualizeForgedData(dirName)
%visualizeForgedData Visualize the forged point cloud
%dirName: directory containing attacked point cloud

if(~exist('dirName', 'var'))
    config_file = 'config.json';
    config = jsondecode(fileread(config_file));
    paths = config.paths;

    dirName = paths.visualize_dir;
end

N = 0;

figure,
for idx = 0:N
    %for bin files
    fid = fopen([dirName filesep sprintf('%06d.bin', idx)],'rb');
    pc = fread(fid,[4 inf],'single')';
    fclose(fid);
    pcshow(pc(:,1:3));
    fprintf('Program paused. Press enter to continue.\n');
    pause;
end


end