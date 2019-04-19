function deleteAllDatasetFiles()
% deleteAllDatasetFiles deletes all files in dataset directory.
config_file = 'config.json';
config = jsondecode(fileread(config_file));
paths = config.paths;
myFolder = paths.dataset_dir;
% Get a list of all files in the folder with the desired file name pattern.

for folder = {'Easy', 'Hard', 'Medium'}
  for att = {'Attack1', 'Attack2', 'Attack3', 'Attack4', 'Attack5', 'Attack6'}
    for attack_folder = {'calib', 'image_2', 'image_2_mod', 'label_2', 'rgb_detections', 'velodyne'}
       del_url = [myFolder filesep folder{1} filesep att{1} filesep attack_folder{1}];
       if ~isfolder(del_url)
          continue
       end
       filePattern = fullfile(del_url, '*.*');
       theFiles = dir(filePattern);
       for k = 1 : length(theFiles)
          baseFileName = theFiles(k).name;
          fullFileName = fullfile(del_url, baseFileName);
          fprintf(1, 'Now deleting %s\n', fullFileName);
          delete(fullFileName);
       end
    end
  end
end