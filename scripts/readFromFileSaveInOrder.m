clear;
clc;
% reading the total files
folderPath='E:\GAC_Files\Markers\Markers_With_White_Backgrounds\Positive_Images\';
% folderPath='E:\GAC_Files\Markers\Markers_With_White_Backgrounds\Negative_Images\';
fileType=fullfile(folderPath,'*.PNG');
imageList=dir(fileType);
numOfImages=length(imageList);
tic
% spmd% rewriting the files in an order
for i=1:numOfImages
    image=imageList(i).name;
    I=imread([folderPath image]);
    I=imrotate(I,180);
    filename=[folderPath 'MarkerWhiteBG_PI_' num2str(i+numOfImages,'%08d') '.PNG'];
    % filename=[folderPath 'MarkerWhiteBG_NI_' num2str(i,'%08d') '.PNG'];
    imwrite(I,filename);
end;
% end;
toc
clear;