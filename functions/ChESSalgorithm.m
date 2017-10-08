function cornerGuess = ChESS_algortihm( I )
%CHESS_ALGORTIHM Summary of this function goes here
%   Detailed explanation goes here
H = fspecial('gaussian',[5 5],2);
r = 10;
n = r/5;
% I = rgb2gray(imread('E:\GAC_Files\Markers\SVMTraining\whiteMarker\27.PNG'));
I2 = imfilter(I,H);
[x,y,~,c1]=imextrema(I2);
imageSize = size(I);
c2=[x(c1==0),y(c1==0)];
% c2=0;
if numel(c2)<2
    c2=corner(I);
end
figure,contourf(I,40),hold on, plot(c2(:,1),c2(:,2),'ro');
flag=0;
for i=1:numel(c2)/2
    if c2(i,1)>15 && c2(i,1)<imageSize(1)-15 && c2(i,2)>15 && c2(i,2)<imageSize(2)-15
        flag=flag+1;
        c(flag,:) = [c2(i,1),c2(i,2)];
    end
end
% c = [20,30;50,55;43,47;50,54;49,47;54,56;55,56;55,55;47,47;25,21;50,38;47,47;48,43;46,51;48,54;49,49;55,47;40,40;30,20;40,40];
% c = [30,30;46,50;49,45;40,40;32,34;71,28;30,30];
x = n*[0 2 4 5 5 5 4 2 0 -2 -4 -5 -5 -5 -4 -2].';
y = n*[-5 -5 -4 -2 0 2 4 5 5 5 4 2 0 -2 -4 -5].';
for rows = 1:100
    for cols = 1:100
        points(((100*rows)-100+cols),:) = [rows,cols];
    end
end
for ic=1:numel(c)/2
    pointsOnCircle = round([x+c(ic,1),y+c(ic,2)]);
    % Summation Response - Addition
    SRadd = [0 1 2 3 8 9 10 11].';
    SRsubtract = [4 5 6 7 12 13 14 15].';
    k1=pointsOnCircle(SRadd+1,:);
    k2=pointsOnCircle(SRsubtract+1,:);
    k3(:,1)=k1(:,2);
    k3(:,2)=k1(:,1);
    k1=k3;
    k4(:,1)=k2(:,2);
    k4(:,2)=k2(:,1);
    k2=k4;
    j=length(k3);
    for i=1:j
        ISRadd(i,1) = I(k1(i,1),k1(i,2));
        ISRsubtract(i,1) = I(k2(i,1),k2(i,2));
    end
    responseSR(ic,1) = abs(sum(ISRadd)-sum(ISRsubtract));
    
    % Difference Response - Subtraction
    DRadd = [0 1 2 3 4 5 6 7].';
    DRsubtract = [8 9 10 11 12 13 14 15].';
    k5=pointsOnCircle(DRadd+1,:);
    k6=pointsOnCircle(DRsubtract+1,:);
    k7(:,1)=k5(:,2);
    k7(:,2)=k5(:,1);
    k5=k7;
    k4(:,1)=k6(:,2);
    k4(:,2)=k6(:,1);
    k6=k4;
    j=length(k7);
    for i=1:j
        IDRadd(i,1) = I(k5(i,1),k5(i,2));
        IDRsubtract(i,1) = I(k6(i,1),k6(i,2));
    end
    responseDR(ic,1) = abs(sum(IDRadd)-sum(IDRsubtract));
    
    % Mean Response
    x1=x/n;
    y1=y/n;
    pointsOnMeanCircle = round([x1+c(ic,1),y1+c(ic,2)]);
    xqm=points(:,1);
    yqm=points(:,2);
    xvm=pointsOnMeanCircle(:,1);
    yvm=pointsOnMeanCircle(:,2);
    inm = inpolygon(xqm,yqm,xvm,yvm);
    pointsInsideLocalCircle = [xqm(inm),yqm(inm)];
    
    p1 = pointsInsideLocalCircle;
    p2(:,1) = p1(:,2);
    p2(:,2) = p1(:,1);
    for i2=1:numel(pointsInsideLocalCircle)/2
        ILocalMean(i2,:) = I(p2(i2,1),p2(i2,2));
    end
    localMean = mean(ILocalMean);
    
    xq=points(:,1);
    yq=points(:,2);
    xv=pointsOnCircle(:,1);
    yv=pointsOnCircle(:,2);
    in = inpolygon(xq,yq,xv,yv);
    pointsInsideNeighbourCircle = [xq(in),yq(in)];
    
    p3 = pointsInsideNeighbourCircle;
    p4(:,2) = p3(:,1);
    p4(:,1) = p3(:,2);
    for i3=1:numel(pointsInsideNeighbourCircle)/2
        IneighbourMean(i3,:) = I(p4(i3,1),p4(i3,2));
    end
    neighbourMean = mean(IneighbourMean);
    responseMR(ic,1) = abs(neighbourMean-localMean);
    clear p1 p2 p3 p4;
end
responseTR = responseSR-responseDR-(16*responseMR);
[~,index] = max(responseTR);
pointsOnCircle = round([x+c(index,1),y+c(index,2)]);
cornerGuess = [c(index,1),c(index,2)];
hold on, plot(c(index,1),c(index,2),'g*','MarkerSize',10);
% hold on,plot(pointsOnCircle(:,1),pointsOnCircle(:,2),'g*');
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
close;
end

