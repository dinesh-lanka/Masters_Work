clear;
clc;
% reading the total files
folderPath='C:\Users\JAI\Desktop\Markers\Positive\';
fileType=fullfile(folderPath,'*.PNG');
imageList=dir(fileType);
numOfImages=length(imageList);
tic
% spmd% rewriting the files in an order
for i=1:numOfImages
    image=imageList(i).name;
    I=imread([folderPath image]);
    I=imrotate(I,90);
    filename=[folderPath 'PI_' num2str(i,'%d') '.PNG'];
    imwrite(I,filename);
end;
% end;
toc
clear;