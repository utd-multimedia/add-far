# ADD-FAR: Attacked Driving Dataset for Forensics Analysis and Research

## Introduction
This repository releases the code for our MMSys 2019 paper. In this paper, we present a
new dataset, ADD-FAR (Attacked Driving Dataset for Forensics Analysis and Research) that contains forged driving scenarios based on KITTI Vision Benchmark Suite [1]. This dataset is created by identifying objects of interest using automated 3D object detection and carrying out the attacks with different levels of risk as defined in our earlier ACM MM 2018 (see references below) [2]. 

## Location
The dataset can be obtained [here](https://utdallas.box.com/v/add-far).

## Prerequisites
 - MATLAB
 - KITTI dataset (available [here](http://www.cvlibs.net/datasets/kitti/))
 - KITTI MATLAB Toolbox (available [here](https://s3.eu-central-1.amazonaws.com/avg-kitti/devkit_object.zip) or the object development kit from [here](http://www.cvlibs.net/datasets/kitti/eval_object.php?obj_benchmark=3d))

## Preparing data folders
 Create the folder hierarchy
  * Dataset Folder
    * Easy
      * Attack1
      * Attack2
      * Attack3
      * Attack4
      * Attack5
      * Attack6
    * Medium
      * Attack1
      * Attack2
      * Attack3
      * Attack4
      * Attack5
      * Attack6
    * Hard
      * Attack1
      * Attack2
      * Attack3
      * Attack4
      * Attack5
      * Attack6

Each Attack folder will consist of subfolders:
 - velodyne
 - calib
 - label_2
 - label_2_mod
 - rgb_detection.txt
 - rgb_detection_mod.txt

## Usage
To create automated attacks run the script `createAttacks_8_21.m`
This script works as follows:
First, 2D object detection results available with the F-Pointnet training dataset [3] as a ground truth are loaded using `loadRGBDetectionResults.m`.
Next, it creates various sub-directories for dataset generation as described earlier.

#### For additive attack:
Select the frame from which the forged object is supposed to be extracted. This is done by appropriately setting the `idx_Ex` variable in the script.
Once the desired frame is selected, the script will select the first entry from the list of detected objects as a forged object. It will crop the corresponding 2d image and point cloud and insert them in all frames. 
#### For all other attacks:
For each detected object in the scene, it is modified appropriately to carry out respective attacks.
For each attack, the modified point cloud data is stored in the folder `velodyne` in the attack directory. While modified RGB data is stored in the `image_2_mod` folder.

## Requirements for other datasets:
In order to use other dataset:
1. The dataset must have following information: 3d point cloud data, rgb images, calibration data (camera parameters for both LiDAR and RGB camera as well as relative transformation between these two sensors), 2D object detection results (if 2D object detection results are not available, one can use any off-the shelf 2 object detectors and store the results in the format compatible with the KITTI 3D object recognition dataset)
2. The I/O functions required for loading the dataset must be appropriate.

## Acknowledgement:
This material is based upon work supported by the US Army Research Office (ARO) Grant W911NF-17-1-0299. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the ARO.

This code uses the scripts provided in KITTI dataset for loading the dataset.

## References:
[1] Kanchan Bahirat, Umang Shah, Alvaro A Cardenas, and Balakrishnan Prabhakaran. 2018. ALERT: Adding a Secure Layer in Decision Support for Advanced Driver Assistance System (ADAS). In 2018 ACM Multimedia Conference on Multi- media Conference. ACM, 1984–1992.

[2] Andreas Geiger, Philip Lenz, Christoph Stiller, and Raquel Urtasun. 2017. 3D Object Detection Evaluation 2017. http://www.cvlibs.net/datasets/kitti/eval_object.php?obj_benchmark=3d.

[3] Charles R Qi, Wei Liu, Chenxia Wu, Hao Su, and Leonidas J Guibas. 2017. Frustum PointNets for 3D Object Detection from RGB-D Data. arXiv preprint arXiv:1711.08488 (2017).

License
----

This work is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-nc-sa/3.0/).
