function[] = writePC2Bin(P, a1_dir)

a=dir([sprintf('%s\\velodyne\\',a1_dir) '/*.bin']);
cnt1=size(a,1);

fid = fopen(sprintf('%s\\velodyne\\%06d.bin', a1_dir, cnt1),'w');
fwrite(fid, P', 'single');
fclose(fid);
end