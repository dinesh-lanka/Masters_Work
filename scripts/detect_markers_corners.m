clear;
clc;
tic
% Suppressing all warnings
warning('off','all');
% Path of cascade trained file
cascadeDetectorFilePath='E:\GitHub\Masters_Work\XML_Files\markerDetector.xml';
% Reading the image
image=imread('E:\GAC_Files\PW6glider\03_MEASUREMENT_images\cam_2\frame_000002.bmp');
% Loading the initial cps guess points
initialcpsfilelocation='E:\GAC_Files\PW6glider\cps\cam_2\cps_img00001.dat';
% Writing the new guess points to another data file
newcpsfilelocation='E:\GAC_Files\Test_Runs\Cobrawing\cps_image00001.dat';
% Detecting the corners for all the markers
x_corner_guesssing(image,cascadeDetectorFilePath,initialcpsfilelocation,newcpsfilelocation);
toc