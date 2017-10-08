
function [xcorner,ycorner,C,FLAG] = x_corner_detection_dg_structs...
         (Img,winsize,dots,smoothing,sigma,maxsubpixshift,delta,dotPattern,boolCPSrefine,catchy_struct)
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
if nargin < 10 || nargin==7
    catchy = false;
else
    catchy = true;
end
if nargin==7
   dotPattern=false;
   boolCPSrefine=false;
end

%smoothing gaussian filter:
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
% gaussian filter applied on image if catchy search and imfilter is activated
if catchy ==true
    if catchy_struct.bol_filter_img == true
    
        Img = conv2(double(Img),g,'same');
    end
end

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
for i = 1 :numel(xn)
    
    xguess = xn(i)+psize;
    yguess = yn(i)+psize;
    
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
    % Skew-symmteric check for a saddle point
    if (dotPattern==true && boolCPSrefine==true)
        H = fspecial('gaussian',[3,3],2);
        I=I_conv;
        cornerGuessFromChESS = ChESSalgorithm(I);
        I=imfilter(I,H);
        k = 5;
        n = ((k)*2)+1;
        beta = -k:0;
        imageSize = size(I);
        for x = (1+k):(imageSize(2)-k)
            for y = (1+k):(imageSize(1)-k)
                for j=1:numel(beta)
                    b(j)= abs(double(I(y-beta(j),x-beta(j))) + double(I(y+beta(j),x+beta(j))) - double(I(y-beta(j),x+beta(j))) - double(I(y+beta(j),x-beta(j))));
                    Faxy(x,y) = (1/n^2)*sum(sum(b));
                end
            end
        end
        [maximas,index] = max(Faxy);
        [~,globalmaxima_Y] = max(maximas);
        globalmaxima_X = index(globalmaxima_Y);
        yglobalmaxima_Y = yguess+globalmaxima_Y-((width_y-delta)+1)-psize;
        xglobalmaxima_X = xguess+globalmaxima_X-((width_x-delta)+1)-psize;
        figure , contourf(I_conv,40);
        set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
        hold on, plot(globalmaxima_X,globalmaxima_Y,'r^','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',10);
        hold on, plot(cornerGuessFromChESS(1),cornerGuessFromChESS(2),'rv','LineWidth',2,'MarkerEdgeColor','g','MarkerFaceColor','r','MarkerSize',10);
    end
    
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    [zfindy,zfindx,c,flag] = func_findcornerpeak_circle_new(Mat, I_conv_search, s_in, t_in, maxsubpixshift);
%     figure , contourf(I_conv_search,40);
    hold on, plot(zfindx+delta,zfindy+delta,'ro','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','y','MarkerSize',8);
    hold on, plot(zfindx+delta,zfindy+delta,'ro','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','y','MarkerSize',8);
      
    ynull(:,i) = yguess+zfindy-((width_y-delta)+1)-psize;
    xnull(:,i) = xguess+zfindx-((width_x-delta)+1)-psize;
    
%     subpixel:
    if flag>0
        tsub=[0;0;0];
        ssub=[0;0;0];
        for q=1:flag
            tsub(q,1) = t(zfindy(q)+delta,zfindx(q)+delta);
            ssub(q,1) = s(zfindy(q)+delta,zfindx(q)+delta);
        end
    
        ycorner(:,i) = ynull(:,i)+tsub;
        xcorner(:,i) = xnull(:,i)+ssub;
        C(:,i)=c;
        FLAG(i)=flag;
    else
        ycorner(:,i) = ynull(:,i);
        xcorner(:,i) = xnull(:,i);
        C(:,i)=c;
        FLAG(i)=flag;
    end
    clear tsub ssub 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     
    % Checking the distance between the peaks detected by
    % func_findcornerpeak_circle_new and peak detected by skew-symmetry.
    if (dotPattern==true && boolCPSrefine==true)
        p1=[xglobalmaxima_X-delta,yglobalmaxima_Y-delta];
%         hold on, plot (xglobalmaxima_X,yglobalmaxima_Y,'bo');
        p2=[xcorner,ycorner];
        for i=1:(numel(p2)/2)
            distbwPeaks(i)=abs(norm(p1-p2(i,:)));
        end
        [minDistance,index]=min(distbwPeaks);
        % Selecting the peak point that is closest to the saddle point. If the
        % distance is high then the previous guess is considered as x-corner
        if minDistance < 4
            xcorner = xcorner(index);
            ycorner = ycorner(index);
        else
            xcorner = dots(1,1);
            ycorner = dots(1,2);
        end
        
    end
    close;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     

end


