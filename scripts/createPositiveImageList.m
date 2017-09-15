clear;
clc;
tic
folderPath='E:\GAC_Files\Markers\Markers_Any_Background\Positive\';
filePattern=fullfile(folderPath,'*.png');
images=dir(filePattern);
len=length(images);
for i=1:len
    filename=[folderPath images(i).name];
    info(i).imageFilename=filename;
    info(i).objectBoundingBoxes=[2,2,98,98];
end

save(fullfile('E:\GitHub\Masters_Work\XML_Files\','positiveImageListMarkersAnyBackground'),'info');
clear;
toc
