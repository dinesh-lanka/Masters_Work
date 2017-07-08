clear;
clc;
%     folderPath='D:\Markers\Positive\';
%     fileType=fullfile(folderPath,'*.PNG');
%     n=length(dir(fileType));
filePath='E:\GAC_Files\Positive\136.PNG';
image=imread(filePath);
[xcornerguess,ycornerguess]=Xcorner_estimator(imadjust(rgb2gray(image)));
% figure, imshow(image);
hold on;
plot(xcornerguess,ycornerguess,'r*');