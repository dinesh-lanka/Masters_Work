clear;
clc;
% cd 'C:\Users\JAI\Desktop\Markers\';
folderPath='E:\GitHub\Masters_Work\';
detectorFilename='XML_Files\markerDetectorAnyBackground.xml';
cascadeDetectorFilePath=[folderPath detectorFilename];
detector=vision.CascadeObjectDetector(cascadeDetectorFilePath);
% detector.MergeThreshold=8;

for i=1
    filepath = 'E:\GAC_Files\Images_From_Test_Runs\Cobra_Propeller\Cobra_prop\pictures\cam_1\FT_000300.bmp';
%     filepath='E:\GAC_Files\Images_From_Test_Runs\0001.tiff';
%     filepath='E:\GAC_Files\Images_From_Test_Runs\run_30\Cam1\Cam1RH_Seq30_11h22m18s725ms_0000.bmp';
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