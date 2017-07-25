% This script creates a .dat file that is required to be given to OpenCV for
% cascade training.

clear;
clc;
filePath = 'E:\GitHub\Masters_Work\XML_Files\';
filePathToWrite = [filePath 'Markers_BlackBG_positiveImageList' '.dat'];
fileID = fopen(filePathToWrite,'w');

load('E:\GitHub\Masters_Work\XML_Files\positiveImageListMarkersWithBlackBG.mat');
len = length(info);
for i=1:len
    imageFilePath = info(i).imageFilename;
    box = info(i).objectBoundingBoxes;
    fprintf(fileID,'%s\t\t %d\t %d\t %d\t %d\t %d\r\n',imageFilePath,1,box(1),box(2),box(3),box(4));    
end

fclose(fileID);

clear;