clear;
clc;

% folderPath='C:\Users\JAI\Desktop\Markers\Positive';
folderPath='C:\Users\JAI\Desktop\Markers\Negative';
% folderPathNew='C:\Users\JAI\Desktop\Markers\Negative';
% newImageNumber=length(dir(fullfile(folderPathNew,'\*.png')));
filePattern=fullfile(folderPath,'\*.png');
images=dir(filePattern);
len=length(images);
for i=1:len
    filename=[folderPath '\' num2str(i,'%d') '.PNG'];
    I=imread(filename);
    I=imrotate(I,90);
    %     I=imresize(I, [100 100]);
    %     filenameNew=[folderPathNew '\' num2str(i+newImageNumber,'%d') '.PNG'];
    filename=[folderPath '\' num2str(i+len,'%d') '.PNG'];
    imwrite(I,filename);
end
