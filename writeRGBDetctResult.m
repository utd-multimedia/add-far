function[] = writeRGBDetctResult(C1, C_1, a1_dir, a2_dir)
%writeRGBDetctResult write RGB detection results to file
%C1: original data
%C_1: adjusted data
%a1_dir: directory for C1 output, corresponds to set 1
%a2_dir: directory for C_1 output, corresponds to set 2

a=dir([a1_dir filesep 'image_2' filesep '*.png']);
cnt1=size(a,1);


fid = fopen([a1_dir filesep 'rgb_detections' filesep 'rgb_detection.txt'],'a+');

for i = 1:size(C1{1,1},1)
    pathN = [a2_dir filesep 'image_2' filesep sprintf('%06d.png',cnt1-1)];
    label = C1{1,2}(i);
    confd = C1{1,3}(i);
    xmin = C1{1,4}(i);
    ymin = C1{1,5}(i);
    xmax = C1{1,6}(i);
    ymax = C1{1,7}(i);
    
    fprintf(fid,'%s %d %f %d %d %d %d\n', pathN, label, confd, xmin, ymin, xmax, ymax);
end

fclose(fid);

a=dir([a1_dir filesep 'image_2_mod' filesep '*.png']);
cnt1=size(a,1);
fid = fopen([a1_dir filesep 'rgb_detections' filesep 'rgb_detection_mod.txt'],'a+');

for i = 1:size(C_1{1,1},1)
    pathN = [a2_dir filesep 'image_2_mod' filesep sprintf('%06d.png',cnt1-1)];
    label = C_1{1,2}(i);
    confd = C_1{1,3}(i);
    xmin = C_1{1,4}(i);
    ymin = C_1{1,5}(i);
    xmax = C_1{1,6}(i);
    ymax = C_1{1,7}(i);
    
    fprintf(fid,'%s %d %f %d %d %d %d\n', pathN, label, confd, xmin, ymin, xmax, ymax);
end

fclose(fid);

end