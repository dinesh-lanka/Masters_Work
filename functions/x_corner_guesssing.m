function x_corner_guesssing(folderPathforImages,startImage,endImage,cascadeDetectorFilePath,initialcpsfilelocation,newcpsfilelocation)
%X_CORNER_GUESSSING Summary of this function goes here
%   Detailed explanation goes here

for i=startImage:endImage
    %     Reading the total number of images in the folder and extracting the
    %     image according to start and end image
    fileType=fullfile(folderPathforImages,'*.BMP');
    imageList=dir(fileType);
    imageName=imageList(i).name;
    image=imread([folderPathforImages imageName]);
    
    % Now reading the initial cps file from the initial cps file location and
    % picking the file corresponding to the start image  selected
    if (i-startImage)==0
        cpsFilesList=dir(fullfile(initialcpsfilelocation,'*.dat'));
        initialcpsfile=cpsFilesList(i).name;
        initialcpsfile=[initialcpsfilelocation initialcpsfile];
    end
    fileID=fopen(initialcpsfile,'r');
    A=textscan(fileID,'%f %f');
    A=cell2struct(A,{'xcorner','ycorner'},2);
    noOfElements=numel(A.xcorner);
    
    % Writing the new guess points to another data file
    newcpsfile=[newcpsfilelocation 'cps_image_' num2str(i,'%06d') '.dat'];
    fileID2=fopen(newcpsfile,'w');
%     figure, imshow(image);
    % Detecting the corners for all the markers
    for j=1:noOfElements
        xcornerguess=A.xcorner(j);
        ycornerguess=A.ycorner(j);
        markerCornerGuess(j,:)=marker_detection(image,xcornerguess,ycornerguess,cascadeDetectorFilePath);
        fprintf(fileID2,'%e\t %e\r\n',markerCornerGuess(j,:));
%         hold on;
%         plot(markerCornerGuess(j,1),markerCornerGuess(j,2),'g*');
        clear markerCornerGuess;
    end
    initialcpsfile=newcpsfile;
    % Closing the files
    fclose(fileID2);
    fclose(fileID);
    
end
end