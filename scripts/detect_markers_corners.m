clear;
clc;
tic
image=imread('C:\Users\JAI\Desktop\Markers\run_30\Cam1\Cam1RH_Seq30_11h22m18s725ms_0000.bmp');
[imageWidth,imageHeight]=size(image);
aspectRatio=int64(imageWidth/imageHeight);
xcornerguess=220;
ycornerguess=1172;
cascadeDetectorFilePath='C:\Users\JAI\Desktop\Markers\XML_Lists\markerDetector.xml';
markerCornerGuess=marker_detection(image,imageWidth,imageHeight,aspectRatio,xcornerguess,ycornerguess,cascadeDetectorFilePath);
toc