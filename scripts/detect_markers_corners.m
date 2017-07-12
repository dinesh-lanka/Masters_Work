clear;
clc;
tic
% Suppressing all warnings
warning('off','all');
% Path of cascade trained file
cascadeDetectorFilePath='E:\GitHub\Masters_Work\XML_Files\markerDetector.xml';
% Reading the image
folderPathforImages='E:\GAC_Files\run_30\Cam2\';
% Loading the initial cps guess points
initialcpsfilelocation='E:\GAC_Files\run_30\cps\cam_2\';
% Writing the new guess points to another data file
newcpsfilelocation='E:\GAC_Files\Test_Runs\Cobrawing\cam_2\';
% Giving the images to be read
startImage=1;
endImage=720;
% Detecting the corners for all the markers
x_corner_guesssing(folderPathforImages,startImage,endImage,cascadeDetectorFilePath,initialcpsfilelocation,newcpsfilelocation);
toc