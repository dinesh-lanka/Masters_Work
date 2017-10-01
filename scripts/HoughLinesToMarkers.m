close all;
clear;clc;
tic
I = imread('E:\GAC_Files\Markers\Markers_Any_Background\Positive\PI_00009732.PNG');
% I = imresize(I,[80 80]);
% I = imread('E:\GAC_Files\Markers\Capture.png');
[Height,Width] = size(I);
% H = fspecial('gaussian',[3 3],5);
% I = imfilter(I,H);
BW = edge(rgb2gray(I),'canny');
% figure, imshow(BW);
% Creating hough transform
[H,T,R] = hough(BW);
% Finding the peaks
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
% Plotting the lines
lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
figure, imshow(I), hold on
max_len = 0;
for k = 1:length(lines)
    if lines(k).point1(1)+10<Height && lines(k).point1(2)+10<Width && ...
            lines(k).point2(1)+10<Height && lines(k).point2(2)+10<Width...
            && lines(k).point1(1)-10>0 && lines(k).point1(2)-10>0 ...
            && lines(k).point2(1)-10>0 && lines(k).point2(2)-10>0
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
        % Determine the longest line segment
        len = norm(lines(k).point1 - lines(k).point2);
        linesSorted(k,:) = [len,k,lines(k).theta];
    else
        linesSorted(k,:) = [NaN,k,NaN];
    end
end
linesSorted = sortrows(linesSorted,3,'ascend');
% for i=1:k
%     tempTheta = linesSorted(i,3);
%     for j =i+1:k
%         if(linesSorted(j,3) == tempTheta) && (~isnan(linesSorted(j,3)))
%             P1=[lines(linesSorted(i,2)).point1,0];
%             P2=[lines(linesSorted(i,2)).point2,0];
%             P3=[lines(linesSorted(j,2)).point1,0];
%             P4=[lines(linesSorted(j,2)).point2,0];
%         end
%     end
% end
toc