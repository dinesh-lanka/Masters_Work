function cornerGuessFFT = xcorner_FFTalgorithm( I , radiusofCircularROI )
%XCORNER_FFTALGORITHM Summary of this function goes here
%   Detailed explanation goes here
% Algorithm developed based on the research work of Qi Zhang and Caihua
% Xiong titled "A New Chessboard Corner Detection Algorithm with Simple Thresholding"
imageSize=size(I);
r=radiusofCircularROI;
M=32;
i=1:M;
center = size(I)/2;
if size(I,3)==3
    I=rgb2gray(I);
end
H = fspecial('gaussian',[5 5],5);
I = imfilter(I,H);
% [xc,yc,~,coef]=imextrema(I);
% cornersAll = [xc(coef==0) yc(coef==0)];cornersAll=corner(I);
sizeofPoints = prod(imageSize);
points = zeros(sizeofPoints,2);
count = 0;
for rows = 1:imageSize(2)
    for cols = 1:imageSize(1)
        if rows-r>0 && rows+r<imageSize(2) && cols-r>0 && cols+r<imageSize(1)
            count=count+1;
            points(count,:) = [rows,cols];
        end
    end
end
cornersAll=points;
flag=0;
% Corner Response function
for count=1:numel(cornersAll)/2
    if cornersAll(count,1)>r && cornersAll(count,1)<imageSize(1)-r && cornersAll(count,2)>r && cornersAll(count,2)<imageSize(2)-r
        flag=flag+1;
        c(flag,:)= cornersAll(count,:);
    end
end
if exist('c','var')
    n=numel(c)/2;
    cornerResponseFunc = zeros(n,1);
    for count=1:n
        uc=c(count,1);
        vc=c(count,2);
        ui=round((r*cos(2*pi*i/M))+uc).';
        vi=round((r*sin(2*pi*i/M))+vc).';
        for j=1:M
            X(j,1)=I(vi(j,1),ui(j,1));
        end
        f = fft(X);
        fcomp = abs(f);
        cornerResponseFunc(count,1) = fcomp(3)- fcomp(2);
    end
    [~,index] = max(cornerResponseFunc);
    cornerGuessFFT = c(index,:);
else
     cornerGuessFFT = floor(imageSize/2);
end
figure, contourf(I,30);hold on, plot(cornerGuessFFT(1),cornerGuessFFT(2),'r^','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',10);set(gcf,'Units','normalized','outerposition',[0 0 1 1]);
close;
end

