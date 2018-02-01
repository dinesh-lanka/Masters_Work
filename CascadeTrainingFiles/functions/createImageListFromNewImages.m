function folderPathofNewPositiveImages = createImageListFromNewImages(newPositiveImagesFolderPath, newImagesType, saveDestination, destfileName)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Changing the images to PNG 100x100x3 unit8 images and saving them in a
% temporary folder for training of classifier
newPositiveImagesFolderPath = [newPositiveImagesFolderPath '\'];
imageType = newImagesType;
newImagesType = ['*.' newImagesType];
newfilePattern = fullfile(newPositiveImagesFolderPath, newImagesType);
newimages = dir(newfilePattern);
newlen = length(newimages);
mkdir([saveDestination '\temp_Positives']);
tempFolder = [saveDestination '\temp_Positives'];
folderPathofNewPositiveImages = [tempFolder '\'];
flag = 0;
for i = 1:newlen
    if newimages(i).isdir == 1
        flag = flag + 1;
    else
        newfilename = [newPositiveImagesFolderPath newimages(i).name];
        I = imread(newfilename);
        if size(I, 3) ~= 3
            I = cat(3, I, I, I);
        end
        I = imresize(I, [100 100]);
        % saveFileAs = [tempFolder '\' num2str(i - flag, '%d') '.PNG'];
        saveFileAs = [tempFolder '\' num2str(i - flag, '%d') '.' imageType];
        imwrite(I, saveFileAs);
        info(i - flag).imageFilename = saveFileAs;
        info(i - flag).objectBoundingBoxes = [2, 2, 98, 98];
    end
end
save(fullfile(saveDestination, destfileName), 'info');
end


