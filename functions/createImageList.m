function createImageList( newimagesFolderPath,imagesFolderPath,imageType,saveDestination,destfileName )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Changing the images to PNG 100x100x3 unit8 images and saving them in a
% temporary folder for training of classifier
newimagesFolderPath = [newimagesFolderPath '\'];
newfilePattern=fullfile(newimagesFolderPath);
newimages=dir(newfilePattern);
newlen=length(newimages);
mkdir([saveDestination '\temp']);
tempFolder = [saveDestination '\temp'];
flag = 0;
for i=1:newlen
    if newimages(i).isdir == 1
        flag = flag+1;
    else        
        newfilename=[newimagesFolderPath newimages(i).name];
        I = imread(newfilename);
        if size(I,3)~=3
            I = cat(3, I, I, I);        
        end
        I = imresize(I,[100 100]);
        saveFileAs=[tempFolder '\' num2str(i-flag,'%d') '.PNG'];
        imwrite(I,saveFileAs);
        info(i-flag).imageFilename=saveFileAs;
        info(i-flag).objectBoundingBoxes=[2,2,98,98];
    end
end
flag1 = 0;
imagesFolderPath = [imagesFolderPath '\'];
imageType=['*.' imageType];
filePattern=fullfile(imagesFolderPath,imageType);
images=dir(filePattern);
len=length(images);
for i=1:len
    if images(i).isdir == 1
         flag1 = flag1+1;
    else
        filename=[imagesFolderPath images(i).name];
        info(i+newlen-flag1-flag).imageFilename=filename;
        info(i+newlen-flag1-flag).objectBoundingBoxes=[2,2,98,98];
    end
end
save(fullfile(saveDestination,destfileName),'info');

end

