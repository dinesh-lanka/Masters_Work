% This script creates a .dat file that is required to be given to OpenCV for
% cascade training. 
% P.S: Read all the comments to check if any line of code must be
% uncommented to proceed with the script run.

clear;
clc;
filePath = 'E:\GitHub\Masters_Work\XML_Files\';
% Uncomment this to create a data file with the list for markers with black
% background
% filePathToWrite = [filePath 'Markers_BlackBG_positiveImageList' '.dat'];

% Uncomment this to create a data file witht the list for markers with
% white background
filePathToWrite = [filePath 'Markers_WhiteBG_positiveImageList' '.dat'];

fileID = fopen(filePathToWrite,'w');

% Uncomment this to create a list for markers with black background
% load('E:\GitHub\Masters_Work\XML_Files\positiveImageListMarkersWithBlackBG.mat');

% Uncomment this to create a list for markers with white background 
load('E:\GitHub\Masters_Work\XML_Files\positiveImageListMarkersWithWhiteBG.mat');

len = length(info);
for i=1:len
    imageFilePath = info(i).imageFilename;
    box = info(i).objectBoundingBoxes;
    fprintf(fileID,'%s %d %d %d %d %d\r\n',imageFilePath,1,box(1),box(2),box(3),box(4));    
end

fclose(fileID);

clear;