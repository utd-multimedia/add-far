function[] = writePC2Bin(P, a1_dir)
%writePC2Bin write point cloud data to bin file
%P: point cloud
%a1_dir: output directory

a=dir([a1_dir filesep 'velodyne' filesep '*.bin']);
cnt1=size(a,1);

fid = fopen([a1_dir filesep 'velodyne' filesep sprintf('%06d.bin', cnt1)],'w');
fwrite(fid, P', 'single');
fclose(fid);
end