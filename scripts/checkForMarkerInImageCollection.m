clear;
clc;
tic
cascadeDetectorFilePath = 'E:\GitHub\Masters_Work\XML_Files\markerDetectorBlackBG.xml';
detector = vision.CascadeObjectDetector(cascadeDetectorFilePath);

imagesfolderPath = 'E:\GAC_Files\Markers\Markers_With_Black_Backgrounds\Negative_Images';
% imagesfolderPath = 'E:\GAC_Files\Markers\Buffer';
imagesInFolderPath = fullfile(imagesfolderPath,'*.PNG');
imagesList = dir(imagesInFolderPath);
imagesCount = length(imagesList);

for i = 1:imagesCount
    imagefile = fullfile(imagesfolderPath,imagesList(i).name);
    I = imread(imagefile);
    box = step(detector,I);
    if ~isempty(box)
        bufferfolderpath = 'E:\GAC_Files\Markers\Buffer';
        bufferimagefilepath = [bufferfolderpath '\' 'PI_Buffer_' num2str(i,'%8d') '.PNG'];
        imwrite(I,bufferimagefilepath);
        delete(imagefile);
    end;
end;
toc