function cornerGuessPoints = marker_detection_MATLAB(image,xcornerguess,ycornerguess,cascadeDetectorFilePath)
%MARKER_DETECTION Summary of this function goes here
% This function validates if the marker exists around the corner mentioned
% here and returns an initial guess of the marker x-corner.

%Detailed explanation goes here
% Function arguments significance
% image: The image in which the marker must be detected
% xcornerguess: The initial x-coordinate guess of the marker x-corner
% ycornerguess: The initial y-coordinate guess of the marker x-corner
% cascadeDetectorFilePath: The file path of the XML generated from cascade
% training for object detection.

[imageWidth,imageHeight]=size(image);
% aspectRatio=int64(imageWidth/imageHeight);
% The aspect ratio is for future use
aspectRatio=1;
% The imread function of matlab reads the image as height by width and
% hence the original points from the real image are actually inverted. This
% is the reason the points are used in a reverse manner. However the final
% corner points are returned in a correct order such that the function
% could directly be used. Few of the steps and numerical values were
% developed based on a trial & error approach.
temp=xcornerguess;
xcornerguess=ycornerguess;
ycornerguess=temp;
clear temp;

% Calling the marker detection function
detector=vision.CascadeObjectDetector(cascadeDetectorFilePath);
% detector.MergeThreshold=10;

% Initializing a search window of minimum size
searchWindowSize=1;
markerDetected=0;
box=[0,0,0,0];

% Running a while loop until the window size becomes 160-by-160 window
while (markerDetected~=1) && (searchWindowSize<40)
    %     Since the image hass an aspect ratio, a square window cannot be
    %     used to search. Hence,a rectangular window determined by the
    %     aspect ratio is used. However now only the aspect ratio is given
    %     a value of one.
    xstartlimit=xcornerguess-searchWindowSize;
    ystartlimit=(aspectRatio*ycornerguess)-searchWindowSize;
    xendlimit=xcornerguess+searchWindowSize;
    yendlimit=(aspectRatio*ycornerguess)+searchWindowSize;
    searchWindowSize=searchWindowSize+1;
    if xstartlimit<1
        xstartlimit=1;
    end
    if ystartlimit<1
        ystartlimit=1;
    end
    if xendlimit>imageWidth
        xendlimit=imageWidth;
    end
    if yendlimit>imageHeight
        yendlimit=imageHeight;
    end
    
    searchWindow=image(xstartlimit:xendlimit,ystartlimit:yendlimit);
    box=step(detector,searchWindow);
    if ~isempty(box)
        %detectedImg=insertObjectAnnotation(searchWindow,'rectangle',box, '*');
        %figure, imshow(detectedImg);
        markerDetected=1;
        x1=box(1,1);
        x2=box(1,1)+box(1,3);
        y1=box(1,2);
        y2=box(1,2)+box(1,3);
        
        I=searchWindow(y1:y2,x1:x2);
        s=size(I);
        xcorner=s(1,1)/2;
        ycorner=s(1,2)/2;
        %         figure,imshow(I);
        %         hold on;
        %         plot(xcorner,ycorner,'r*');
        xrealcornerguess=xstartlimit+box(1,2)+xcorner;
        yrealcornerguess=ystartlimit+box(1,1)+ycorner;
        cornerGuessPoints(1,1)=yrealcornerguess-(2*aspectRatio);
        cornerGuessPoints(1,2)=xrealcornerguess-(2);
    else
        markerDetected=0;
        
    end
end

if isempty(box)
    cornerGuessPoints=[ycornerguess,xcornerguess];
    warning('Marker not found. Assigning the initial search entry.');
end

