clear;
clc;
tic
image=imread('E:\GAC_Files\run_30\Cam2\Cam2JH_Seq30_11h22m20s617ms_0227.bmp');
[imageWidth,imageHeight]=size(image);
aspectRatio=int64(imageWidth/imageHeight);
xcornerguess=570;
ycornerguess=500;
cascadeDetectorFilePath='E:\GitHub\Masters_Work\XML_Files\markerDetector.xml';
markerCornerGuess=marker_detection(image,imageWidth,imageHeight,aspectRatio,xcornerguess,ycornerguess,cascadeDetectorFilePath);
figure, imshow(image);
hold on;
plot(markerCornerGuess(1,4),markerCornerGuess(1,3),'g*');
toc