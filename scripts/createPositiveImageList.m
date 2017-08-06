clear;
clc;
tic
folderPath='E:\GAC_Files\Markers\Markers_With_Black_Backgrounds\Positive_Images\';
filePattern=fullfile(folderPath,'*.png');
images=dir(filePattern);
len=length(images);
for i=1:len
    filename=[folderPath images(i).name];
    info(i).imageFilename=filename;
    info(i).objectBoundingBoxes=[1,1,99,99];
end

save(fullfile('E:\GitHub\Masters_Work\XML_Files\','positiveImageListMarkersWithBlackBG'),'info');
clear;
toc
