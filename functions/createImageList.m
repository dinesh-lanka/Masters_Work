function createImageList( imagesFolderPath,imageType,saveDestination,destfileName )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
imagesFolderPath = [imagesFolderPath '\'];
imageType=['*.' imageType];
filePattern=fullfile(imagesFolderPath,imageType);
images=dir(filePattern);
len=length(images);
for i=1:len
    filename=[imagesFolderPath images(i).name];
    info(i).imageFilename=filename;
    info(i).objectBoundingBoxes=[2,2,98,98];
end

save(fullfile(saveDestination,destfileName),'info');

end

