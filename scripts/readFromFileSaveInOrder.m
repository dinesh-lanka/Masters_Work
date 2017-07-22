clear;
clc;
% reading the total files
folderPath='E:\GAC_Files\Markers_With_Black_Backgrounds\Negative_Images\';
fileType=fullfile(folderPath,'*.PNG');
imageList=dir(fileType);
numOfImages=length(imageList);
tic
% spmd% rewriting the files in an order
for i=1:numOfImages
    image=imageList(i).name;
    I=imread([folderPath image]);
%     I=imrotate(I,0);
    filename=[folderPath 'NI_' num2str(i+numOfImages,'%08d') '.PNG'];
    imwrite(I,filename);
end;
% end;
toc
clear;