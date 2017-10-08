function [ maximaValues, LmaximasIndexes, minimaValues, LminimasIndexes, pointsOnCircleArranged, intensity, sGrad ] = circlePointsGradient( I,r,cX,cY,flag )
%CIRCLEPOINTSGRADIENT Summary of this function goes here
%   Detailed explanation goes here
% Getting points on the perimeter of the circle
H = fspecial('gaussian',[3 3],2);
I =imfilter(I,H);
% if flag
%     I =im2bw(I);
% end
theta = 0 : 15 : 359;
x = ((r * cos(theta) + cX)).';
y = ((r * sin(theta) + cY)).';
pointsOnCircle = [x,y];

pointsArranged = [3,16,11,24,6,19,1,14,9,22,4,17,12,7,20,2,15,10,23,5,18,13,8,21,3];
for i = 1:25
    j = pointsArranged(i);
    pointsOnCircleArranged(i,:) = pointsOnCircle(j,:);
end

% figure, imshow(I),
% hold on,plot(pointsOnCircleArranged(:,1),pointsOnCircleArranged(:,2),'g*'),grid on;
for i=1:numel(pointsOnCircleArranged)/2
    intensity(1,i) = I(int16(pointsOnCircleArranged(i,2)),int16(pointsOnCircleArranged(i,1)));
end

sGrad = gradient(double(intensity));
% sDiff=diff(double(intensity));
[maximaValues, LmaximasIndexes] = findpeaks(sGrad);
[minimaValues, LminimasIndexes] = findpeaks(-sGrad);

end

