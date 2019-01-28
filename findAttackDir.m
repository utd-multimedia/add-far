function[a1_dir, a2_dir] = findAttackDir(riskF_Ex, attack)

easy_dir = 'D:\3DForensics\Datasets\KITTI_3D_ObjDet\AugmentedDataset\Easy\';
med_dir = 'D:\3DForensics\Datasets\KITTI_3D_ObjDet\AugmentedDataset\Medium\';
hard_dir = 'D:\3DForensics\Datasets\KITTI_3D_ObjDet\AugmentedDataset\Hard\';

easy_dir1 = 'dataset\KITTI\object\AugmentedDataset\Easy\';
med_dir1 = 'dataset\KITTI\object\AugmentedDataset\Medium\';
hard_dir1 = 'dataset\KITTI\object\AugmentedDataset\Hard\';

if(riskF_Ex > 0.6)                              %% Hard
    a1_dir = sprintf('%s%s', easy_dir, attack);
    a2_dir = sprintf('%s%s', easy_dir1, attack);
elseif(riskF_Ex > 0.3 && riskF_Ex <= 0.6)       %% Medium
    a1_dir = sprintf('%s%s', med_dir, attack);
    a2_dir = sprintf('%s%s', med_dir1, attack);
else                                            %% Easy
    a1_dir = sprintf('%s%s', hard_dir, attack);
    a2_dir = sprintf('%s%s', hard_dir1, attack);
end

end