clear;
tic
% Reading images
folderPathofImages = 'E:\GAC_Files\Markers\Markers_With_Black_Backgrounds\Negative_Images';
filesToReadType = fullfile(folderPathofImages,'*.PNG');
Images = dir(filesToReadType);
noOfImages = length(Images);
% For saving inverted images
filePathToSave = 'E:\GAC_Files\Markers\Markers_With_White_Backgrounds\Negative_Images';
filesInNewPath = fullfile(filePathToSave,'*.PNG');
ImagesInNewPath = dir(filesInNewPath);
noOfImagesInNewPath = length(ImagesInNewPath);

for i = 1:noOfImagesInNewPath
    imageAbsolutePath = Images(i).name;
    imageAbsolutePath = fullfile(folderPathofImages,imageAbsolutePath);
    I = imread(imageAbsolutePath);
    I(:,:,:) = 255-I(:,:,:);
%     imshow(I);
    filename = ['NI_' num2str(i+noOfImagesInNewPath,'%08d')];
    saveImages(I,filePathToSave,filename);    
end
toc