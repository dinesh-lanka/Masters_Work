clear;
clc;
tic
image=imread('E:\GAC_Files\PW6glider\03_MEASUREMENT_images\cam_2\frame_000001.bmp');
figure, imshow(image);
[imageWidth,imageHeight]=size(image);
% aspectRatio=int64(imageWidth/imageHeight);
% The aspect ratio is for future use
aspectRatio=1;
xcornerguess=310;
ycornerguess=1019;
cascadeDetectorFilePath='E:\GitHub\Masters_Work\XML_Files\markerDetector.xml';
markerCornerGuess=marker_detection(image,imageWidth,imageHeight,aspectRatio,xcornerguess,ycornerguess,cascadeDetectorFilePath);
hold on;
plot(markerCornerGuess(1,2),markerCornerGuess(1,1),'g*');
toc