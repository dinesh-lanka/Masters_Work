% folderPath: The folder path of the image from which images must be cut
% saveFilePath: The folder path to which the images must be saved
% listToFilesInFolder: List containing the images in the folder targeted by folderPath
% cutImageLimit: The limit upto how many images from the folder must be cut

clear;
clc;

folderPath='D:\IPCT_Testdaten\Cobra_prop\pictures\cam_2\';
saveFilePath='D:\Markers\Negative\';
fileType=fullfile(folderPath,'*.BMP');
listToFilesInFolder=dir(fileType);
len=length(listToFilesInFolder);
startImage=1000;
endImage=1001;
% Calling the function to cut smaller images from a bigger image
cut_From_Images_Save(folderPath,saveFilePath,listToFilesInFolder,startImage,endImage);