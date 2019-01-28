function[] = copyfilesV_new(a1_dir, calib_dir, image_dir, label_dir, idx, Im)

%%%% copying files
a=dir([sprintf('%s\\image_2\\',a1_dir) '/*.png']);
cnt1=size(a,1);

copyfile(sprintf('%s\\%06d.txt', calib_dir, idx),sprintf('%s\\calib\\%06d.txt', a1_dir, cnt1));
copyfile(sprintf('%s\\%06d.png', image_dir, idx),sprintf('%s\\image_2\\%06d.png', a1_dir, cnt1));
copyfile(sprintf('%s\\%06d.txt', label_dir, idx),sprintf('%s\\label_2\\%06d.txt', a1_dir, cnt1));
imwrite(Im, sprintf('%s\\image_2_mod\\%06d.png', a1_dir, cnt1));
end