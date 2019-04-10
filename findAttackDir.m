function[a1_dir, a2_dir] = findAttackDir(riskF_Ex, attack)
%findAttackDir returns directories for attacked data
%args:
%  riskF_Ex risk factor value
%  attack Name of attack type
%returns:
%  a1_dir: directory for Set 1
%  a2_dir: directory for Set 2

config_file = 'config.json';
config = jsondecode(fileread(config_file));
paths = config.paths;

easy_dir = paths.easy_dir;
med_dir = paths.med_dir;
hard_dir = paths.hard_dir;

easy_dir1 = paths.easy_dir_1;
med_dir1 = paths.med_dir_1;
hard_dir1 = paths.hard_dir_1;

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