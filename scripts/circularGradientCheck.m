clear;
clc;
tic
close all;
warning('off','all');
% I = imread('D:\Markers_UsedForTraining\X_corners\Positive\12.png');
fID = fopen('E:\GAC_Files\Images_From_Test_Runs\PW6glider\cps\cam_1\cps_img00005.dat','r');
cps = textscan(fID,'%f %f');
dots(:,1) = cps{:,1};
dots(:,2) = cps{:,2};
Img = imread('E:\GAC_Files\Images_From_Test_Runs\PW6glider\03_MEASUREMENT_images\cam_1\frame_000012.bmp');
% Img = rgb2gray(Img);
winsize = [30,30];
smoothing = 10;
sigma = 2;
maxsubpixshift = 5;
delta = 10;
dotPattern = 1;
boolCPSrefine = 1;
r = 5;
I=Img;
c = size(I);
markersFound = 0;
for i=1:(numel(dots)/2)
    [xcorner,ycorner,C,FLAG] = x_corner_detection_dg_structs...
        (Img,winsize,dots(i,:),smoothing,sigma,maxsubpixshift,delta,dotPattern,boolCPSrefine);
    dots2(i,1)=xcorner;dots2(i,2)=ycorner;
    cX = xcorner;
    cY = ycorner;
    d=cX+r;
    [ maximaValues, LmaximasIndexes, minimaValues, LminimasIndexes, pointsOnCircleArranged, intensity, sGrad] = circlePointsGradient( I,r,cX,cY,true);
    [ maximaValuesGray, LmaximasIndexesGray, minimaValuesGray, LminimasIndexesGray, pointsOnCircleArrangedGray, intensityGray, sGradGray] = circlePointsGradient( I,r,cX,cY,false);
    if numel(maximaValuesGray)==2 && numel(minimaValuesGray)==2
        radialDistance1 =  norm(pointsOnCircleArranged(LmaximasIndexesGray(1)),pointsOnCircleArranged(LmaximasIndexesGray(2)));
        radialDistance2 =  norm(pointsOnCircleArranged(LminimasIndexesGray(1)),pointsOnCircleArranged(LminimasIndexesGray(2)));
        if (radialDistance1>=0.7*d) && (radialDistance2>=0.7*d)
            disp(['Marker found at corner ID ' num2str(i,'%d')])
            markersFound = markersFound+1;
            % figure ,
            % subplot(2,1,1), plot(intensity,'r*-'),ylim([-2 2]),title('Intensity curve for binary image');
            % subplot(2,1,2), plot(intensityGray,'r*-'),title('Intensity curve for gray scale image');
            % figure ,
            % subplot(2,1,1), plot(sGrad,'r*-'),ylim([-2 2]),title('Gradient curve for binary image');
            % subplot(2,1,2), plot(sGradGray,'r*-'),ylim([-255 255]), title('Gradient curve gray image');
        end
    end
end
figure (1), imshow(Img);
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
hold on, plot (dots(:,1),dots(:,2),'ro'),hold on, plot (dots2(:,1),dots2(:,2),'g*');
markersFound
toc