clear;
clc;
tic
dotPattern = true;
% dotPattern = false;
% I = (rgb2gray(imread('E:\GAC_Files\Markers\Capture.PNG')));
I = rgb2gray(imread('E:\GAC_Files\Markers\Markers_Any_Background\Positive\PI_00001081.PNG'));
% I = rgb2gray(imread('E:\GAC_Files\Markers\Markers_Any_Background\Positive\16.PNG'));
% Ic = size(I)./2; 
% if dotPattern
%     I1 = imgaussfilt(I,1);
% else
%     I1 = I;
% end   
% [x,y,z,c]=imextrema(I1);
% saddlePoints = [x(c==0),y(c==0)];
% i=numel(saddlePoints)/2;
% for k=1:1:i
%     X = [Ic;saddlePoints(k,:)];
%     distances(k,:)=pdist(X,'euclidean');
% end
%  [Value,Index]=min(distances);
%  s=saddlePoints(Index,:);
s = guessXCorner(I,dotPattern);
% figure, imshow(I);
% hold on, plot(s(1),s(2),'g*');
% hold on, plot(x(c==0),y(c==0),'ro');
toc