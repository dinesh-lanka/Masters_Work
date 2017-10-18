function cornerGuess = xcorner_ChESSalgorithm( I,c2 )
%CHESS_ALGORTIHM Summary of this function goes here
%   Detailed explanation goes here
% figure,imshow(I),title('After background removal');
% close;
% [x,y,~,c1]=imextrema(I2);
% % if maskSize>0
%     H = fspecial('gaussian',[3 3],3);
%     I = imfilter(I,H);
% end

% c2=[x(c1==0),y(c1==0)];
% c2=0;
% if numel(c2)<2
%     c2=corner(I);
% end
% imshow(I),hold on, plot(c2(:,1),c2(:,2),'g*');
flag=0;
r = 10;
n = r/5;
M = 32;
im = 1:M;
actualImage = I;
imageSize = size(I);
center = imageSize/2;
corners = corner(I);
for i=1:numel(corners)/2
    if corners(i,1)>r && corners(i,1)<=imageSize(1)-r && corners(i,2)>r && corners(i,2)<=imageSize(2)-r
        flag=flag+1;
        cornersatCenter(flag,:) = [corners(i,1),corners(i,2)];
    end
end
flag=0;
% figure,contourf(I,30);
for i=1:numel(c2)/2
    if c2(i,1)>r && c2(i,1)<=imageSize(1)-r && c2(i,2)>r && c2(i,2)<=imageSize(2)-r
        flag=flag+1;
        c(flag,:) = [c2(i,1),c2(i,2)];
    end
end
cExists=exist('c','var');
ccExists=exist('cornersatCenter','var');
if ~cExists
    if ccExists
        c=cornersatCenter;
    else
        c=center;
    end
end

% x = n*[0 1 2 3 4 5 5 5 5 5 5 5 4 3 2 1 0 -1 -2 -3 -4 -5 -5 -5 -5 -5 -5 -5 -4 -3 -2 -1].';
% y = n*[-5 -5 -5 -5 -4 -3 -2 -1 0 1 2 3 4 5 5 5 5 5 5 5 4 3 2 1 0 -1 -2 -3 -4 -5 -5 -5].';
sizeofPoints = prod(imageSize);
points = zeros(sizeofPoints,2);
count = 0;
while count<sizeofPoints
    for rows = 1:imageSize(2)
        for cols = 1:imageSize(1)
            count=count+1;
            points(count,:) = [rows,cols];            
        end
    end
end

for ic=1:numel(c)/2
    % ointsOnCircle = round([x+c(ic,1),y+c(ic,2)]);
    uc=round(c(ic,1));
    vc=round(c(ic,2));
    ui=round((r*cos(2*pi*im/M))+uc).';
    vi=round((r*sin(2*pi*im/M))+vc).';
    pointsOnCircle = [vi,ui];
    %     hold on,plot(pointsOnCircle(:,1),pointsOnCircle(:,2),'r.');
    %     set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    % Summation Response - Addition
    SRadd = [0 1 2 3 4 5 6 7 16 17 18 19 20 21 22 23].';
    SRsubtract = [8 9 10 11 12 13 14 15 24 25 26 27 28 29 30 31].';
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
    DRadd = (0:15).';
    DRsubtract = (16:31).';
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
    % x1=(n-1)*x/n;
    % y1=(n-1)*y/n;
    % pointsOnMeanCircle = round([x1+c(ic,1),y1+c(ic,2)]);
    rm=r*(n-1)/n;
    ucm=round(c(ic,1));
    vcm=round(c(ic,2));
    uim=round((rm*cos(2*pi*im/M))+ucm).';
    vim=round((rm*sin(2*pi*im/M))+vcm).';
    pointsOnMeanCircle = [uim,vim];
    %     hold on,plot(pointsOnMeanCircle(:,1),pointsOnMeanCircle(:,2),'g.');
    xqm=points(:,1);
    yqm=points(:,2);
    xvm=pointsOnMeanCircle(:,1);
    yvm=pointsOnMeanCircle(:,2);
    inm = inpolygon(xqm,yqm,xvm,yvm);
    pointsInsideLocalCircle = [xqm(inm),yqm(inm)];
    %     hold on,plot(pointsInsideLocalCircle(:,1),pointsInsideLocalCircle(:,2),'y.');
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
    clear p1 p2 p3 p4 c2;
end

% close;
responseTR = responseSR-responseDR-(32*responseMR);
[~,index] = max(responseTR);
% pointsOnCircle = round([x+c(index,1),y+c(index,2)]);
cornerGuess = [c(index,1),c(index,2)];
% % figure, contourf(actualImage,30), hold on, plot(c(index,1),c(index,2),'r^','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','y','MarkerSize',10);
% % hold on, plot(c2(:,1),c2(:,2),'g*'),title('Corner Prediction by ChESS algorithm');
% % % hold on,plot(pointsOnCircle(:,1),pointsOnCircle(:,2),'g*');
% % set(gcf,'units','normalized','outerposition',[0 0 1 1]);
% % close;
end