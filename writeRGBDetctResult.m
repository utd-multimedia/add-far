function[] = writeRGBDetctResult(C1, C_1, a1_dir, a2_dir)

a=dir([sprintf('%s\\image_2\\',a1_dir) '/*.png']);
cnt1=size(a,1);


fid = fopen(sprintf('%s\\%s', a1_dir,'rgb_detections\rgb_detection.txt'),'a+');

for i = 1:size(C1{1,1},1)
    pathN = sprintf('%s\\image_2\\%06d.png', a2_dir, cnt1-1);
    label = C1{1,2}(i);
    confd = C1{1,3}(i);
    xmin = C1{1,4}(i);
    ymin = C1{1,5}(i);
    xmax = C1{1,6}(i);
    ymax = C1{1,7}(i);
    
    fprintf(fid,'%s %d %f %d %d %d %d\n', pathN, label, confd, xmin, ymin, xmax, ymax);
end

fclose(fid);

a=dir([sprintf('%s\\image_2_mod\\',a1_dir) '/*.png']);
cnt1=size(a,1);
fid = fopen(sprintf('%s\\%s', a1_dir,'rgb_detections\rgb_detection_mod.txt'),'a+');

for i = 1:size(C_1{1,1},1)
    pathN = sprintf('%s\\image_2_mod\\%06d.png', a2_dir, cnt1-1);
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