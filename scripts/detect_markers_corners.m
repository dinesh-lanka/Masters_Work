clear;
clc;
tic
image=imread('E:\GAC_Files\PW6glider\03_MEASUREMENT_images\cam_2\frame_000001.bmp');
figure, imshow(image);
xcornerguess=310;
ycornerguess=1019;
cascadeDetectorFilePath='E:\GitHub\Masters_Work\XML_Files\markerDetector.xml';
markerCornerGuess=marker_detection(image,xcornerguess,ycornerguess,cascadeDetectorFilePath);
hold on;
plot(markerCornerGuess(1,1),markerCornerGuess(1,2),'g*');
toc