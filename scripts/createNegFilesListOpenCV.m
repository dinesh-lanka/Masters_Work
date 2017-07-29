% This script creates a .dat file that contains the file paths to the
% negative images
% P.S: Read all the comments to check if any line of code must be
% uncommented to proceed with the script run.

clear;
clc;
filePathForDat = 'E:\GitHub\Masters_Work\XML_Files\';

% Uncomment this to create a data file with the list for markers with
% black background
% filePathToWrite = [filePathForDat 'Markers_BlackBG_negativeImageList' '.dat'];

% Uncomment this to create a data file witht the list for markers with
% white background
filePathToWrite = [filePathForDat 'Markers_WhiteBG_negativeImageList' '.dat'];

fileID = fopen(filePathToWrite,'w');

% Uncomment this to create a data file witht the list for markers with
% black background
% filePath = 'E:\GAC_Files\Markers\Markers_With_Black_Backgrounds\Negative_Images\';

% Uncomment this to create a data file witht the list for markers with
% white background
filePath = 'E:\GAC_Files\Markers\Markers_With_White_Backgrounds\Negative_Images\';

fileType = dir(fullfile(filePath, '*.PNG'));
len = length(fileType);

for i=1:len
    fileLocation = [filePath fileType(i).name];
    fprintf(fileID,'%s\r\n',fileLocation);
end

fclose(fileID);
clear;
