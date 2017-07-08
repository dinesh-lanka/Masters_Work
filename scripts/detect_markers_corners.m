clear;
clc;
tic
image=imread('E:\GAC_Files\run_30\Cam2\Cam2JH_Seq30_11h22m20s392ms_0200.bmp');
[imageWidth,imageHeight]=size(image);
aspectRatio=int64(imageWidth/imageHeight);
xcornerguess=918;
ycornerguess=1035;
cascadeDetectorFilePath='E:\GitHub\Masters_Work\XML_Files\markerDetector.xml';
markerCornerGuess=marker_detection(image,imageWidth,imageHeight,aspectRatio,xcornerguess,ycornerguess,cascadeDetectorFilePath);
toc