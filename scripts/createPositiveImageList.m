clear;
clc;
folderPath='C:\Users\JAI\Desktop\Markers\Positive\';
filePattern=fullfile(folderPath,'*.png');
images=dir(filePattern);
len=length(images);
for i=1:len
    filename=[folderPath images(i).name];
    info(i).imageFilename=filename;
    info(i).objectBoundingBoxes=[1,1,99,99];
end

save(fullfile('C:\Users\JAI\Desktop\Markers\XML_Lists\','positiveimagelist'),'info');
clear;

