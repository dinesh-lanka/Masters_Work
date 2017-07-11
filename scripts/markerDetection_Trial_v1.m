clear;
clc;
% cd 'C:\Users\JAI\Desktop\Markers\';
folderPath='E:\GitHub\Masters_Work\';
detectorFilename='XML_Files\markerDetector.xml';
cascadeDetectorFilePath=[folderPath detectorFilename];
detector=vision.CascadeObjectDetector(cascadeDetectorFilePath);
% detector.MergeThreshold=10;

for i=1
    filepath='E:\GAC_Files\run_30\Cam1\Cam1RH_Seq30_11h22m22s850ms_0495.bmp';
    imagefile=filepath;
    %     imagefile=[filepath '\Images\' '009.BMP'];
    %     filename=[filepath '\Positive\' num2str(i, '%d') '.PNG'];
    %     filename=[filepath '\Negative\' num2str(i, '%d') '.PNG'];
    I=imread(imagefile);
    box=step(detector,I);
    detectedImg=insertObjectAnnotation(I,'rectangle',box, 'Marker');
    figure, imshow(detectedImg);
end;
% close all;