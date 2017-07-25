% This script creates a .dat file that contains the file paths to the
% negative images

clear;
clc;
filePathForDat = 'E:\GitHub\Masters_Work\XML_Files\';
filePathToWrite = [filePathForDat 'Markers_BlackBG_negativeImageList' '.dat'];
fileID = fopen(filePathToWrite,'w');

filePath = 'E:\GAC_Files\Markers\Markers_With_Black_Backgrounds\Negative_Images\';
fileType = dir(fullfile(filePath, '*.PNG'));
len = length(fileType);

for i=1:len
    fileLocation = [filePath fileType(i).name];
    fprintf(fileID,'%s\r\n',fileLocation);
end

fclose(fileID);
clear;
