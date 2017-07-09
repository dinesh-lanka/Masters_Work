clear;
clc;
% reading the total files
folderPath='E:\GAC_Files\Negative\';
fileType=fullfile(folderPath,'*.PNG');
imageList=dir(fileType);
numOfImages=length(imageList);
tic
% spmd% rewriting the files in an order
for i=1:numOfImages
    image=imageList(i).name;
    I=imread([folderPath image]);
%     I=imrotate(I,90);
    filename=[folderPath 'NI_' num2str(i+numOfImages,'%d') '.PNG'];
    imwrite(I,filename);
end;
% end;
toc
clear;