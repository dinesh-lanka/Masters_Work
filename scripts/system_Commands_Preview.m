% This is a script to run the executable files generated of the C++ files
% developed in Visual Studio IDE
clear;
clc;
% Running the OpenCV executable via command line arguments
% command ='cd C:\opencv\build\x64\vc14\bin';
filePath = 'C:\opencv\build\x64\vc14\bin\Markers_WhiteBG_positiveImageList.dat';
fileID = fopen(filePath,'r');
A=textscan(fileID,'%s %d %d %d %d %d\r\n');
size =cellfun('length',A(1));
dos('cd C:\opencv\build\x64\vc14\bin');
% creating a .vec file for the markers with black background
command = strcat('opencv_createsamples.exe',...
           ' -info Markers_WhiteBG_positiveImageList.dat',...
           ' -vec E:\GitHub\Masters_Work\VEC_Files\Markers_WhiteBG_positiveImageList.vec',...
           ' -num', 32, num2str(size,'%d'),...
           ' -w 100 -h 100');
% command='opencv_createsamples.exe -info Markers_BlackBG_positiveImageList.dat -vec Markers_BlackBG_positiveImageList.vec -num 58907 -w 100 -h 100';
dos(command);