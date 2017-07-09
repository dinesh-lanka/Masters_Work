function box = marker_detection(image,imageWidth,imageHeight,aspectRatio,xcornerguess,ycornerguess,cascadeDetectorFilePath)
%MARKER_DETECTION Summary of this function goes here
%   Detailed explanation goes here
temp=xcornerguess;
xcornerguess=ycornerguess;
ycornerguess=temp;
clear temp;
detector=vision.CascadeObjectDetector(cascadeDetectorFilePath);
% detector.MergeThreshold=10;
searchWindowSize=1;
markerDetected=0;
box=[0,0,0,0];


while (markerDetected~=1) && (searchWindowSize<80)
    
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
        detectedImg=insertObjectAnnotation(searchWindow,'rectangle',box, '*');
%         figure, imshow(detectedImg);
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
        box(1,3)=xrealcornerguess-2;
        box(1,4)=yrealcornerguess-(2*aspectRatio);
    else
        markerDetected=0;
        
    end
end

if isempty(box)
    box=[ycornerguess,xcornerguess,0,0];
    warning('Marker not found. Assigning the initial search entry.');
end

