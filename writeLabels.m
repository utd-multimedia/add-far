function[] = writeLabels(objects, label_dir,img_idx)
% parse input file
fid = fopen(sprintf('%s/%06d.txt',label_dir,img_idx),'w');


for i = 1:size(objects,2)
    type = objects(i).type;
    trunc = objects(i).truncation;
    occlus = objects(i).occlusion;
    alpha = objects(i).alpha;
    x1 = objects(i).x1;
    y1 = objects(i).y1;
    x2 = objects(i).x2;
    y2 = objects(i).y2;
    h = objects(i).h;
    w = objects(i).w;
    l = objects(i).l;
    t1 = objects(i).t(1);
    t2 = objects(i).t(2);
    t3 = objects(i).t(3);
    ry = objects(i).ry;
    fprintf(fid, '%s %.2f %d %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f\n', type, trunc, occlus, alpha, x1, y1, x2, y2, h, w, l, t1, t2, t3, ry);
end

fclose(fid);

end