function x_corner_guesssing(image,cascadeDetectorFilePath,initialcpsfilelocation,newcpsfilelocation)
%X_CORNER_GUESSSING Summary of this function goes here
%   Detailed explanation goes here

fileID=fopen(initialcpsfilelocation,'r');
A=textscan(fileID,'%f %f');
A=cell2struct(A,{'xcorner','ycorner'},2);
noOfElements=numel(A.xcorner);

% Writing the new guess points to another data file
fileID2=fopen(newcpsfilelocation,'w');
% figure, imshow(image);
% Detecting the corners for all the markers
for i=1:noOfElements
    xcornerguess=A.xcorner(i);
    ycornerguess=A.ycorner(i);
    markerCornerGuess(i,:)=marker_detection(image,xcornerguess,ycornerguess,cascadeDetectorFilePath);
    fprintf(fileID2,'%e\t %e\r\n',markerCornerGuess(i,:));
%     hold on;
%     plot(markerCornerGuess(i,1),markerCornerGuess(i,2),'g*');
    clear markerCornerGuess;
end
% Closing the files
fclose(fileID2);
fclose(fileID);

end

