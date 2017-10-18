function cornerGuessPoints = marker_detection(image,xcornerguess,ycornerguess,cascadeDetectorFilePath,cornerDetectorFilePath,projectPath,maxMarkerSize,minMarkerSize,flag,smoothing,winsize,sigma,maxsubpixshift,delta,boolCPSrefine)
%MARKER_DETECTION Summary of this function goes here
% This function validates if the marker exists around the corner mentioned
% here and returns an initial guess of the marker x-corner.

%Detailed explanation goes here
% Significance of the function arguments and variables used
% image: The image in which the marker must be detected
% (xcornerguess,ycornerguess): The initial coordinates of the marker corner
% cascadeDetectorFilePath: The file path of the XML generated from cascade
% training for marker detection.
% cornerDetectorFilePath: The file path of the XML generated from cascade
% training for xcorner detection.
% maxMarkerSize: The size of the box bounding the largest marker in the
% image
% flag: This checks the type of markers.
%   flag=0 if black markers with white background are used
%   flag=1 if white markers with black backgorund are used
% smoothing: "anti-noise"-parameter (idela choice is 10)
% winsize: This is the size of the search window for sub-pixel detector and
% it is recommmended to be less than the value of maxMarkerSize(ideal choice
% would be 20 by 20)
% sigma: The sigma value for the guassian convolution(ideal choice is 2)
% maxsubpixshift: The ideal choice is 5
% delta: The ideal choice is 5
% box: This variable stores the dimensions of the rectangle bounding the marker
% box(1) = x-coordinate of rectangle origin/corner
% box(2) = y-coordinate of rectangle origin/corner
% box(3) = width of the rectangle(bounding box)
% box(4) = height of the rectangle(bounding box)
% markerDetected: This is a boolean variable to check if marker is detected
% or not
% searchWindowSize: This search window is for the marker detection and not
% for the sub-pixel corner estimator
% (xstartlimit,ystartlimit): (top,left) coordinates of the search window
% (xendlimit,yendlimit): (bottom,right) coordinates of the search window
% dots: initial marker corner guess
% [xcorner,ycorner]: Array of corner pairs returned by sub-pixel corner
% detection consisting of the peak points
% boundbox: Holds the size of the rectangle bounding the marker
% cornerGuessPoints: The final guess points along with bounding box size
filterMask=fspecial('gaussian',[3 3],2);
[imageWidth,imageHeight]=size(image);
% aspectRatio=int64(imageWidth/imageHeight);
% The aspect ratio is for future use
aspectRatio=1;
% The imread function of matlab reads the image as height by width and hence the original points from the real image are actually inverted. This is the reason the points are used in a reverse manner. However the final corner points are returned in a correct order such that the function could directly be used. Few of the steps and numerical values were developed based on a trial & error approach.
temp=xcornerguess;
xcornerguess=ycornerguess;
ycornerguess=temp;

% Initializing a search window of minimum size. This search window is for the marker detection and not for the sub-pixel corner estimator
searchWindowSize=round(minMarkerSize/2);
searchWindowLimit=searchWindowSize+15;
% searchWindowLimit=round(maxMarkerSize/2);
markerDetected=0;
box=[0,0,0,0];
cd(projectPath);
% dotPattern = false;
dotPattern = true;
% Running a while loop until the window size becomes equal to maximum size at that point plus 10 pixels. This might lead to wrong detections when the markers are close to each other
while (markerDetected~=1) && (searchWindowSize<searchWindowLimit)
    % Since the image has an aspect ratio, a square window cannot be used to search. Hence,a rectangular window determined by the aspect ratio is used. However now only the aspect ratio is given a value of one.
    xstartlimit=round(xcornerguess-searchWindowSize);
    ystartlimit=round((aspectRatio*ycornerguess)-searchWindowSize);
    xendlimit=round(xcornerguess+searchWindowSize);
    yendlimit=round((aspectRatio*ycornerguess)+searchWindowSize);
    
    % Preventing the search window from exceeding the image dimensions
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
    % Converting the MATLAB image array to image readable by OpenCV library
    searchWindow=cat(3,searchWindow,searchWindow,searchWindow);
    if flag==0
        % Perform inversion only if markers with black background are selected
        searchWindow(:,:,:) = 255-searchWindow(:,:,:);
    end
    % Sending the image as an argument for detecting marker
    % Call for the mex marker detection function
    % figure,imshow(searchWindow);
    box = detectMarker(searchWindow,cascadeDetectorFilePath,cornerDetectorFilePath,maxMarkerSize,minMarkerSize);    
    % Finding an initial guess for the marker corner. Checking if marker is detected. If yes, marker bouding rectangle coordinates are returned
    if (box(1,1)>0)
        markerDetected=1;
        Img=searchWindow;
        center = size(searchWindow);
        figure, imshow(Img);
        set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
        hold on, rectangle('Position',[box(1) box(2) box(3) box(4)], 'LineWidth',2, 'EdgeColor','r');
        windowSize = 5;
        winsize = [round(box(3)/2) round(box(3)/2)];
        % Checking if the x-corner is detected by the MEX function
        if numel(box)>4 && (box(5)~=0) && (box(6)~=0) && (box(7)~=0) && (box(8)~=0)
            hold on, rectangle('Position',[box(5)+box(1) box(6)+box(2) box(7) box(8)], 'LineWidth',2, 'EdgeColor','g');
            xstart=box(5)+box(1);
            xend=xstart+box(7);
            ystart=box(6)+box(2);
            yend=ystart+box(8);
            dots = [round(xstart+(xend-xstart)/2),round(ystart+(yend-ystart)/2)];
            hold on, plot((xstart+(xend-xstart)/2),(ystart+(yend-ystart)/2),'g.'),title('Considering X-corner Center');
        else
            % If x-corner is not detected then the saddle point in the marker bounding region is determined and then the center is predicted
            % Corner prediction using axial skew-symmetry algorithm. This is used when dot pattern is absent.
            if ~dotPattern
                filterSize = 3;
                sigma1 = 3;
                dotsGuess = round(xcorner_skewSymmetryAlgorithm( Img, windowSize, filterSize, sigma1 ));
                xstart=box(1);
                xend=xstart+box(3);
                ystart=box(2);
                yend=ystart+box(4);
                markerCenter = [(xstart+(xend-xstart)/2),(ystart+(yend-ystart)/2)];
                distance = abs(norm(dotsGuess - markerCenter));
                % The corner point must be inside the marker detected region else we consider the marker center as initial guess
                if dotsGuess(1)>box(1) && dotsGuess(1)<box(1)+box(3) && dotsGuess(2)>box(2) && dotsGuess(2)<box(2)+box(4) && distance<5
                    dots=dotsGuess;
                    hold on, plot(dots(1),dots(2),'g+'),title('Skew-Symmetric Corner Determination');
                else
                    dots =[round(xstart+(xend-xstart)/2),round(ystart+(yend-ystart)/2)];
                    hold on, plot(dots(1),dots(2),'gx'),title('Considering Marker Center');
                end
            else
                % Corner prediction using saddle point algorithm. The dot pattern effects the skew-symmetry property.
                xstart=box(1);
                xend=xstart+box(3);
                ystart=box(2);
                yend=ystart+box(4);
                I1 =rgb2gray(Img);
                filterMask=fspecial('gaussian',[3 3],2);
                I1=imfilter(I1,filterMask);
                [x,y,~,c]=imextrema(I1);
                % s = [x(c==1),y(c==1)];hold on, plot(s(:,1),s(:,2),'ro'),title('All Maxima Points');
                saddlePoints = [x(c==0),y(c==0)];
                i=numel(saddlePoints)/2;
                if i>0
                    hold on, plot(saddlePoints(:,1),saddlePoints(:,2),'bo'),title('All Saddle Points');
                    dots =[round(xstart+(xend-xstart)/2),round(ystart+(yend-ystart)/2)];
                    for k=1:1:i
                        distances(k,:) = norm(dots - saddlePoints(k,:));
                    end
                    [Value,Index]=min(distances);
                    exists = exist('distances');
                    
                    if Value < 4 && exists~=0
                        dots=saddlePoints(Index,:);
                        hold on, plot(dots(1),dots(2),'gx'),title('Considering Closest Saddle Point');
                    else
                        % corners = corner(rgb2gray(searchWindow));
                        % corners=xcorner_ChESSalgorithm( rgb2gray(searchWindow),corners );
                        dots =[round(xstart+(xend-xstart)/2),round(ystart+(yend-ystart)/2)];
                        % if abs(norm(dots-corners))<3
                        %     dots = corners;
                        % end
                        hold on, plot(dots(1),dots(2),'gx'),title('Considering Marker Center');
                    end
                else
                    dots =[round(xstart+(xend-xstart)/2),round(ystart+(yend-ystart)/2)];
                    hold on, plot(dots(1),dots(2),'gx'),title('Considering Marker Center');
                end
            end
        end        
        % Using the sub-pixel detection to improve the corner guess
        % dots2 = [ystartlimit+dots(1,1)-1,xstartlimit+dots(1,2)-1];
        dots2 = [dots(1,1),dots(1,2)];
        image1 = rgb2gray(searchWindow);
        set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
        hold on, plot(dots2(1,1), dots2(1,2),'ro'),title('Initial Sub-pixel Guess');
        image1=imfilter(image1,filterMask);
%         image1=image1();
        [xcorner,ycorner,~] = x_corner_detection_dg_struct_modified(image1,winsize,double(dots2),smoothing,sigma,maxsubpixshift,delta,dotPattern,boolCPSrefine);
%         [xcorner,ycorner,c] = x_corner_detection_dg_struct(image1,winsize,double(dots2),smoothing,sigma,maxsubpixshift,delta);
        boundbox = xcorner;
        if box(1,3)> box(1,4)
            boundbox(:,:) = box(1,3);
        else
            boundbox(:,:) = box(1,4);
        end
        cornerGuessPoints = [xcorner+ystartlimit-1,ycorner+xstartlimit-1,boundbox];
        %         end
        figure, imshow(image);
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        hold on, plot(cornerGuessPoints(1,1), cornerGuessPoints(1,2),'g.'),title('Sub-pixel Prediction');
        close;        
    else
        markerDetected=0;
        % cd(projectPath);
    end
    searchWindowSize=searchWindowSize+1.0;
end

if ( isempty(box) || markerDetected == 0)
    dots2 = [ycornerguess,xcornerguess];
    %     dots2 = xCornerPixelEstimation( image, 5 );
    [xcorner,ycorner] = x_corner_detection_dg_struct(image,winsize,dots2,smoothing,sigma,maxsubpixshift,delta);
    cornerGuessPoints = [xcorner,ycorner];
    % cornerGuessPoints=[ycornerguess,xcornerguess];
    figure , imshow(image);
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    hold on, plot(dots2(1,1), dots2(1,2),'ro');
    hold on, plot(cornerGuessPoints(1,1), cornerGuessPoints(1,2),'g.'),title('Sub-pixel Prediction');
    close;
    warning('Marker not found. Using the old algorithm for marker detection.');
end

