clear;
clc;
% cd 'C:\Users\JAI\Desktop\Markers\';
folderPath='E:\GitHub\Masters_Work\';
detectorFilename='XML_Files\markerDetector.xml';
cascadeDetectorFilePath=[folderPath detectorFilename];
detector=vision.CascadeObjectDetector(cascadeDetectorFilePath);
% detector.MergeThreshold=10;

for i=1
    filepath='E:\GAC_Files\PW6glider\03_MEASUREMENT_images\cam_2\frame_000001.bmp';
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