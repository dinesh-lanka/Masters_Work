clear;
clc;
tic
close all;
% I = imread('D:\Markers_UsedForTraining\X_corners\Positive\12.png');
I1 = imread('D:\Markers_UsedForTraining\SVMTraining\blackMarker\60.png');
I = rgb2gray(I1);

r = 20;
c = size(I);
cX = 60;
cY = 43;
d=cX+r;

[ maximaValues, LmaximasIndexes, minimaValues, LminimasIndexes, pointsOnCircleArranged, intensity, sGrad] = circlePointsGradient( I,r,cX,cY,true);
[ maximaValuesGray, LmaximasIndexesGray, minimaValuesGray, LminimasIndexesGray, pointsOnCircleArrangedGray, intensityGray, sGradGray] = circlePointsGradient( I,r,cX,cY,false);
if numel(maximaValues)==2 && numel(minimaValues)==2
    radialDistance1 =  norm(pointsOnCircleArranged(LmaximasIndexes(1)),pointsOnCircleArranged(LmaximasIndexes(2)));
    radialDistance2 =  norm(pointsOnCircleArranged(LminimasIndexes(1)),pointsOnCircleArranged(LminimasIndexes(2)));
    if (radialDistance1>=0.7*d) && (radialDistance2>=0.7*d)
        figure , 
        subplot(2,1,1), plot(intensity,'r*-'),ylim([-2 2]),title('Intensity curve for binary image');
        subplot(2,1,2), plot(intensityGray,'r*-'),title('Intensity curve for gray scale image');
        figure , plot(sGrad,'r*-'),ylim([-2 2]), hold on, title('Gradient curve');
    end
end
toc