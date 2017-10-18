function xCornerIntitalPixelCoordinates = xcorner_skewSymmetryAlgorithm( image, windowSize, filterSize, sigma )
%XCORNERPIXELESTIMATION Summary of this function goes here
%   Detailed explanation goes here
% [~,~,nc]=size(image);
% if nc==3
%     image=rgb2gray(image);
% end
H = fspecial('gaussian',[filterSize filterSize], sigma);
image = imfilter(image,H);
n = ((windowSize)*2)+1;
beta = -windowSize:0;
imageSize = size(image);
for x = (1+windowSize):(imageSize(2)-windowSize)
    for y = (1+windowSize):(imageSize(1)-windowSize)
        for j=1:numel(beta)
            b(j)= abs(double(image(y-beta(j),x-beta(j))) + double(image(y+beta(j),x+beta(j))) - double(image(y-beta(j),x+beta(j))) - double(image(y+beta(j),x-beta(j))));
            Faxy(x,y) = (1/n^2)*sum(sum(b));
        end        
    end
end
[maximas,index] = max(Faxy);
[~,globalmaxima_Y] = max(maximas);
globalmaxima_X = index(globalmaxima_Y);
 xCornerIntitalPixelCoordinates = [ globalmaxima_X,globalmaxima_Y ];
% figure, imshow(image);
% hold on, plot(globalmaxima_X,globalmaxima_Y,'r.');
% cxN = 0.0;
% cD = 1.0;
% cyN = 0.0;
% for i=-windowSize:windowSize
%     for j=-windowSize:windowSize
%     cxN = (globalmaxima_X+i)*Faxy(globalmaxima_X+i,globalmaxima_Y+j)+cxN;
%     cyN = (globalmaxima_Y+j)*Faxy(globalmaxima_X+i,globalmaxima_Y+j)+cyN;
%     cD = Faxy(globalmaxima_X+i,globalmaxima_Y+j)+cD;
%     end
% end
% cx = cxN/cD;
% cy = cyN/cD;
% xCornerIntitalPixelCoordinates = [ cx,cy ];
end

