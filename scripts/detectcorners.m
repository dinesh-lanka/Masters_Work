clear;
clc;
%     folderPath='D:\Markers\Positive\';
%     fileType=fullfile(folderPath,'*.PNG');
%     n=length(dir(fileType));
filePath='C:\Users\JAI\Desktop\Markers\Positive\267.PNG';
image=imread(filePath);
imshow(image);
[xcornerguess,ycornerguess]=Xcorner_estimator(image);
hold on;
plot(xcornerguess,ycornerguess,'r*');