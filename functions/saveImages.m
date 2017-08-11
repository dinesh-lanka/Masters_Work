function saveImages( image,filePathToSave,filename)
%SAVEIMAGES Summary of this function goes here
%   Detailed explanation goes here
fileSavedAs = [filePathToSave '\' filename '.PNG'];
imwrite(image,fileSavedAs);
end

