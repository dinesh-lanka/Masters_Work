function useOldNewNegativeImages( newNegativeImagesFolderPath,oldNegativeImagesFolderPath )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
newNegativeImagesFolderPath = [newNegativeImagesFolderPath '\'];
newfilePattern = fullfile(newNegativeImagesFolderPath);
newimages = dir(newfilePattern);
newlen = length(newimages);
flag = 0;
for i = 1:newlen
    if newimages(i).isdir == 1
        flag = flag + 1;
    else
        newfilename = [newNegativeImagesFolderPath newimages(i).name];
        I = imread(newfilename);
        saveFileAs = [oldNegativeImagesFolderPath '\' 'NewNegative_' newimages(i).name ];
        imwrite(I, saveFileAs);
    end
end
end

