function [xcorner,ycorner,C,FLAG] = x_corner_detection_dg_struct_modified...
    (Img,winsize,dots,smoothing,sigma,maxsubpixshift,~,~,~)
%finds x-corners at the initial guesses 'dots'
%output are the 3 best fitting peaks <xcorner  in the search matrix of size +/-
%winsize around the first guess <dots> coordinates
%Img: Image to search for markers
%winsize: searchregion: [x,y];
%dots: initial guesses, 'n x 2'- vector
%smoothing: "anti-noise"-parameter, little less than half markersize is
%           good
%sigma: 1/4 - 1/3 smoothing is good
%maxsubpixelshift: marker radius
%delta: anti border effects approx. smoothing is good
%catchy_struct: if set, the parameters for catchy search are used

% if nargin==7
%     boolCPSrefine=false;
% end
%smoothing gaussian filter:
delta=0;
x = -smoothing:1:smoothing;
y = x;
[X,Y] = meshgrid(x,y);
%
%original:
g = 1/(2*pi*sigma^2).*exp((-(X.^2+Y.^2)./(2*sigma^2)));
g_x = -X./(2*pi*sigma^4).*exp((-(X.^2+Y.^2)./(2*sigma^2)));
g_y = -Y./(2*pi*sigma^4).*exp((-(X.^2+Y.^2)./(2*sigma^2)));
g_xx = (-1/(2*pi*sigma^4) + X.^2./(2*pi*sigma^6)).*exp((-(X.^2+Y.^2)./(2*sigma^2)));
g_yy = (-1/(2*pi*sigma^4) + Y.^2./(2*pi*sigma^6)).*exp((-(X.^2+Y.^2)./(2*sigma^2)));
g_xy = X.*Y./(2*pi*sigma^6).*exp((-(X.^2+Y.^2)./(2*sigma^2)));

xn = round(dots(:,1)');
yn = round(dots(:,2)');

xnull=zeros(3,length(xn));
ynull=zeros(3,length(xn));

xcorner = zeros(3,length(yn));
ycorner = zeros(3,length(yn));

width_x = winsize(1);
width_y = winsize(2);

%padding gegen imagerand:
psize = 100;
Img = padarray(Img,[psize,psize]);

%schleife über alle punkte:
% for 1 = 1 :numel(xn)

xguess = xn(1)+psize;
yguess = yn(1)+psize;

%convolution:
I_conv = double(Img(yguess-width_y:yguess+width_y,xguess-width_x:xguess+width_x));%conv2(Img,g,'same');
ry = conv2(I_conv,g_x,'same'); %mit x gefaltet!!!
ryy = conv2(I_conv,g_xx,'same');
rx = conv2(I_conv,g_y,'same');
rxx = conv2(I_conv,g_yy,'same');
ryx = conv2(I_conv,g_xy,'same');
rxy=ryx;

%corner-operator:
S = (rxx.*ryy)-(rxy.^2);

%sub-pixel-detection:
t = (ry.*rxy-rx.*ryy)./S;%((rxx.*ryy)-(rxy.^2));
s = (rx.*rxy-ry.*rxx)./S;%((rxx.*ryy)-(rxy.^2));

Mat = double(S(1+delta:end-delta,1+delta:end-delta));
%Mat_search = double(S_search(1+denom:end-denom,1+denom:end-denom));

s_in = double(s(1+delta:end-delta,1+delta:end-delta));
t_in = double(t(1+delta:end-delta,1+delta:end-delta));
I_conv_search = I_conv(1+delta:end-delta,1+delta:end-delta);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Parameters for Skew-symmteric check for a saddle point
I=I_conv_search;
imageSize = size(I);
centerofImage = imageSize/2;
k = 5;
filterSigma=2;

[zfindy,zfindx,c,flag] = func_findcornerpeak_circle_new(Mat, I_conv_search, s_in, t_in, maxsubpixshift);
ynull(:,1) = yguess+zfindy-((width_y-delta)+1)-psize;
xnull(:,1) = xguess+zfindx-((width_x-delta)+1)-psize;

%subpixel:
if flag>0
    tsub=[0;0;0];
    ssub=[0;0;0];
    for q=1:flag
        tsub(q,1) = t(zfindy(q)+delta,zfindx(q)+delta);
        ssub(q,1) = s(zfindy(q)+delta,zfindx(q)+delta);
    end
    
    ycorner(:,1) = ynull(:,1)+tsub;
    xcorner(:,1) = xnull(:,1)+ssub;
    C(:,1)=c;
    FLAG(1)=flag;
else
    ycorner(:,1) = ynull(:,1);
    xcorner(:,1) = xnull(:,1);
    C(:,1)=c;
    FLAG(1)=flag;
end
figure , contourf(I_conv_search,20);
set(gcf,'Units','normalized','outerposition',[0 0 1 1]);
hold on, plot(zfindx,zfindy,'ro','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','y','MarkerSize',8);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Skew-symmetry check. If the point detected is far from the image center then it is rejected and only the ROI center is considered
zfindxIndex = zfindx(~isnan(zfindx)==1);
zfindyIndex = zfindy(~isnan(zfindy)==1);
if flag==0
    ySubPixel = t(zfindy(~isnan(zfindy)==1)+delta,zfindy(~isnan(zfindy)==1)+delta);
    xSubPixel = s(zfindx(~isnan(zfindx)==1)+delta,zfindx(~isnan(zfindx)==1)+delta);
else
    ySubPixel = tsub(~isnan(tsub)==1);
    xSubPixel = ssub(~isnan(ssub)==1);
end
corners1(:,1)=zfindxIndex;
corners1(:,2)=zfindyIndex;
chessGuessCorner=xcorner_ChESSalgorithm(I,corners1);
cornerGuessFFT=xcorner_FFTalgorithm(I,10);
distFFT2ChESS = norm(cornerGuessFFT-chessGuessCorner)<5;
distFFT2Center = norm(cornerGuessFFT-centerofImage)<5;
hold on, plot(chessGuessCorner(1),chessGuessCorner(2),'rv','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',14);
hold on, plot(cornerGuessFFT(1),cornerGuessFFT(2),'ro','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',10);
numcon=length(zfindxIndex);
chessGuessCorner=repmat(chessGuessCorner,numcon,1);
boolCon=(corners1 == chessGuessCorner);
index = all(boolCon,2);
subPixindex=0;
for inum = 1:numcon
    if index(inum)==true
        subPixindex = inum;
    end
end
% The image segment is assumed to be consisting of the marker symmetrically distributed, more or less, around the image center
% Checking if the detected marker corners are near the segment center
distChESS2Center = norm(centerofImage-chessGuessCorner(1,:))<5;

if distChESS2Center && distFFT2ChESS && distFFT2Center && subPixindex~=0
    % One of the peaks' satisifies all the conditions of ChESS,FFT and image center
    xcorner = xcorner(subPixindex);
    ycorner = ycorner(subPixindex);
    if(mod(xcorner(1),1)==0)
        xcorner = xcorner+xSubPixel(subPixindex);
        ycorner = ycorner+ySubPixel(subPixindex);
    end 
else
    % The peak disagrees with the FFT and image center but the FFT agrees with image center. Hence, the FFT value is assumed as the x-corner
    if distChESS2Center && ~distFFT2ChESS && distFFT2Center
        ycorner = yguess+cornerGuessFFT(2)-((width_y-delta)+1)-psize;
        xcorner = xguess+cornerGuessFFT(1)-((width_x-delta)+1)-psize;
    end
    if ~distChESS2Center && ~distFFT2ChESS && distFFT2Center
        ycorner = yguess+cornerGuessFFT(2)-((width_y-delta)+1)-psize;
        xcorner = xguess+cornerGuessFFT(1)-((width_x-delta)+1)-psize;
    end
    % The peak agrees with ChESS and image center but FFT disagrees with image center. Hence, ChESS is assumed as the x-corner
    if distChESS2Center && distFFT2ChESS && ~distFFT2Center && subPixindex~=0
        xcorner = xcorner(subPixindex);
        ycorner = ycorner(subPixindex);
        if(mod(xcorner(1),1)==0)
            xcorner = xcorner+xSubPixel(subPixindex);
            ycorner = ycorner+ySubPixel(subPixindex);
        end
    end
    % Both the peak and FFT conditions fail, then segment center is assumed as marker x-corner
    if ~distChESS2Center && ~distFFT2ChESS && ~distFFT2Center
        ycorner = yguess+centerofImage(2)-((width_y-delta)+1)-psize;
        xcorner = xguess+centerofImage(1)-((width_x-delta)+1)-psize;
    end
end
clear tsub ssub chessGuessCorner;
hold on, plot(xcorner-(xguess-((width_y-delta)+1)-psize),ycorner-(yguess-((width_y-delta)+1)-psize),'r^','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',18);
close
end
%     if boolCPSrefine==true
%         % corners=corner(I);
%         [x,y,~,c]=imextrema(I);
%         corners=[x(c==0),y(c==0)];
%         numcorn = numel(corners)/2;
%         if numcorn==0
%             corners1=round(centerofImage);
%         else
%             flagcon=0;
%             for nuiter=1:numcorn
%                 distCorners = abs(norm(corners(nuiter,:)-centerofImage));
%                 if distCorners<10
%                     flagcon=flagcon+1;
%                     corners1(flagcon,:)=corners(nuiter,:);
%                 end
%             end
%             if ~exist('corners1','var')
%                 corners1=round(centerofImage);
%             end
%         end
%         guess=xcorner_ChESSalgorithm(I,corners1);
%         hold on, plot(guess(1),guess(2),'rv','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',14);
%         if (1+k)<(imageSize(2)-k)
%             n=numel(yn);
%             filterSize = 3;
%             dotsGuess = round(xcorner_skewSymmetryAlgorithm(I, k, filterSize, filterSigma));
%             distance =zeros(1,n);
%             for index=1:n
%                 distance(index) = abs(norm([zfindxIndex(index) zfindyIndex(index)]-dotsGuess));
%                 [dist,minIndex] = min(distance);
%                 if dist < 4
%                     ycorner = ynull(minIndex,1)+ySubPixel(minIndex,1);
%                     xcorner = xnull(minIndex,1)+xSubPixel(minIndex,1);
%                     hold on, plot(dotsGuess(minIndex),dotsGuess(minIndex),'r^','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',10);
%                 end
%             end
%         end
%     end
%     if skewFlag==2
%         n=3;
%         x_=repmat(-n:n,(2*n+1),1);
%         y_=x_.';
%         clear xcorner ycorner;
%         x_ = x_+round(xcornerGuess);
%         y_ = y_+round(ycornerGuess);
%         Inxy=Img(ycornerGuess-n:ycornerGuess+n,xcornerGuess-n:xcornerGuess+n);
%         xcorner=(sum(sum(x_.*double(Inxy))))/sum(sum(double(Inxy)));
%         ycorner=(sum(sum(y_.*double(Inxy))))/sum(sum(double(Inxy)));
%         disp(xcorner);
%         disp(ycorner);
%     end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %