clear;
clc;
warning('off');
tic
% cd 'C:\Users\JAI\Desktop\Markers\';
folderPath='E:\GitHub\Masters_Work\';
detectorFilename='XML_Files\xcornerDetector.xml';
cascadeDetectorFilePath=[folderPath detectorFilename];
detector=vision.CascadeObjectDetector(cascadeDetectorFilePath);
% detector.MergeThreshold=8;

for i=1
    filepath = 'E:\GAC_Files\Markers\SVMTraining\blackMarker\MarkerWhiteBG_PI_00000009.png';
%     filepath = 'E:\GAC_Files\Images_From_Test_Runs\Cobra_Propeller\Cobra_prop\pictures\cam_1\FT_000300.bmp';
%     filepath='E:\GAC_Files\Images_From_Test_Runs\0001.tiff';
%     filepath='E:\GAC_Files\Images_From_Test_Runs\run_30\Cam1\Cam1RH_Seq30_11h22m18s725ms_0000.bmp';
%     filepath='E:\GAC_Files\Images_From_Test_Runs\PW6glider\03_MEASUREMENT_images\cam_2\frame_000002.bmp';
    imagefile=filepath;
    I=imread(imagefile);
    box=step(detector,I);
    detectedImg=insertObjectAnnotation(I,'rectangle',box, 'Marker');
    figure, imshow(detectedImg);
end
temp=size(box);
for i=1:temp(1)
    xstart = box(i,1);
    ystart = box(i,2);
    xend = box(i,1) + box(i,3);
    yend = box(i,2) + box(i,4);
    image = I(ystart:yend,xstart:xend);
    s = guessXCorner(image,true,false);
    corner = [ystart+s(2),xstart+s(1)];
    hold on, plot(corner(2)-1,corner(1)-1,'g*');
end
toc
% close all;