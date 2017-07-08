function cut_From_Images_Save(folderPath,saveFilePath,listToFilesInFolder,startImage,endImage)

parfor i=startImage:endImage
    filepath=[folderPath listToFilesInFolder(i).name];
    I=imread(filepath);
    H=size(I);
    height=H(1,1);
    width=H(1,2);
    for j=1:height
        if (j+100<height) && (j+100<width)
            subImage=I(j:j+100,j:j+100);
            imagesPresent=length(dir(fullfile(saveFilePath,'*.PNG')));
            saveFileAs=[saveFilePath num2str(imagesPresent+1,'%d') '.PNG'];
            imwrite(subImage,saveFileAs);
            %             figure, imshow(subImage);
            
        end;
    end;
    
end
