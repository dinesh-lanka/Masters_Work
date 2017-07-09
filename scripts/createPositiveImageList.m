clear;
clc;
folderPath='E:\GAC_Files\Positive\';
filePattern=fullfile(folderPath,'*.png');
images=dir(filePattern);
len=length(images);
for i=1:len
    filename=[folderPath images(i).name];
    info(i).imageFilename=filename;
    info(i).objectBoundingBoxes=[1,1,99,99];
end

save(fullfile('E:\GitHub\Masters_Work\XML_Files\','positiveimagelist'),'info');
clear;

