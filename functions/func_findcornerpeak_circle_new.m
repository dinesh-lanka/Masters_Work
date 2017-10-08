function [ip_y , ip_x, c,valid_peak_num] = func_findcornerpeak_circle_new(mat, img, s , t, roi )
%========================================================================
% finds the 3 best fitting peaks with corner dedicated characteristics
% mat = matrix where to search for (mat < img)
% img = original image(mat)
% roi ~ half markersize
% ip_y - 3x1 matrix of y - position of the 3 best fitting peaks
% ip_x - 3x1 matrix of x  - position of the 3 best fitting peaks
% c - 3x1 matrix with correlation values of the 3 best fitting peaks
% valid_peak_num - number of detected valid peaks (maximum number is 3)
% if less than 3 peaks are found to be valid candidates ip_x, ip_y and c
% are filled with NaN

%img = uint8(img);
simg = size(img);
%img = adapthisteq(img,'Range','full');
%
%tiefpass von mat:
N = 5;
x = -N:1:N;
y = x;
[X,Y] = meshgrid(x,y);
sigma = 1.25;%round(roi/2);
%
%original:
g = 1/(2*pi*sigma^2).*exp((-(X.^2+Y.^2)./(2*sigma^2)));

mat = conv2(mat,g,'same');
%}
%find 2d min-peaks of mat:
dilmask = ones(5);
%dilmask(5) = 0;
dilimg = imdilate(-mat,dilmask);
peaks = (-mat+0.000001 >= dilimg);

dilimg=imdilate(mat,dilmask);
peaks2=mat >= dilimg;

for i = 1 :numel(peaks)
    if peaks(i) == 1 && s(i) < 2.8 && s(i) > -2.8 && t(i) < 2.8 && t(i) > - 2.8% && mat(i) < 0.1*min(min(mat))
        peaks(i) = 1;
    else
        peaks(i) = 0;
    end
end

for i = 1 :numel(peaks2)
    if peaks2(i) == 1 && s(i) < 1.5 && s(i) > -2 && t(i) < 1.5 && t(i) > - 2% && mat(i) < 0.1*min(min(mat))
        peaks2(i) = 1;
    else
        peaks2(i) = 0;
    end
end



%initial peaks:
[y_peaks,x_peaks] = find(peaks);
npeaks = numel(x_peaks);

%invert peaks to check distances
[y_peaks2,x_peaks2] = find(peaks2);
npeaks2 = numel(x_peaks2);

% Eliminieren von peaks mit Abstand < 2*roi Maxima - Minima zueinander, tkirmse 21.10.2013
BIN=zeros(npeaks,1);
for i=1:npeaks
        for j=1:npeaks2
           r=sqrt((y_peaks(i)-y_peaks2(j))^2+(x_peaks(i)-x_peaks2(j))^2);
           if r< 0.3*roi
               BIN(i)=1;
           end
        end
     
end

for i=1:npeaks-1
    for j=i+1:npeaks
        if BIN(i)~=1
          r=sqrt((y_peaks(i)-y_peaks(j))^2+(x_peaks(i)-x_peaks(j))^2);
          if r< 0.3*roi
               BIN(i)=1;
               BIN(j)=1;
          end
        end
    end
end


index=find(BIN);
y_peaks(index)=[];
x_peaks(index)=[];
npeaks=numel(x_peaks);
clear index BIN npeaks2 y_peaks2 x_peaks2 peaks2;
% Ende peak Eliminieren
%padding:
pad = round(2*roi);
%pad_mat = padarray(mat,[pad,pad]);%,'replicate');
pad_img = padarray(img,[pad,pad]);%,'replicate');

[x,y,z] = circle_complex(0,0,roi,32);

%ox = ones(size(x));
img_on_circle = zeros(1,32);
s_on_circle = zeros(1,32);

%count = 1;
corr_coeff = [];
imgmax=max(max(img));
imgmin=min(min(img));
imgdiff=imgmax-imgmin;
corr_coeff1=zeros(npeaks,1);
corr_coeff2=zeros(npeaks,1);
corr_coeff=zeros(npeaks,1);
flag=zeros(npeaks,1);
flag2=zeros(npeaks,1);
circdiff=zeros(32);
nosignch=zeros(npeaks,1);
for j = 1 : npeaks
    %Vorzeichenwechse über Kreis zählen --> nosignch
    nosignch(j)=0;
    for k = 1 : 32
        img_on_circle(k) = pad_img(y_peaks(j)+pad+y(k),x_peaks(j)+pad+x(k));
        if k==2
            msign=sign(img_on_circle(k)-img_on_circle(k-1));
        elseif k>2
            msignk=sign(img_on_circle(k)-img_on_circle(k-1));
            if norm(msign-msignk)==2 || ((norm(msign-msignk)==1) && msign==0 && nosignch(j)==0)
                msign=msignk;
                nosignch(j)=nosignch(j)+1;
            end
        end
        if k==32
            msignk=sign(img_on_circle(1)-img_on_circle(32));
            if norm(msign-msignk)==2
                msign=msignk;
                nosignch(j)=nosignch(j)+1;
            end
        end
        %s_on_circle(k) = pad_mat(y_peaks(j)+pad+y(k),x_peaks(j)+pad+x(k));
    end
    circdiff(j)=max(img_on_circle)-min(img_on_circle);%(find(img_on_circle~=0))
    flag(j)=circdiff(j)>0.07*imgdiff;
    flag2(j)=(nosignch(j)-2)/2;
    if flag2(j)>1
        flag2(j)=1.8/flag2(j);
    elseif flag2(j)<1
        flag2(j)=0;
    end
   
    corr_coeff1(j) = corr2_own(img_on_circle(1:16),img_on_circle(17:32));
    corr_coeff2(j) = corr2_own(img_on_circle(9:24),img_on_circle([25:32,1:8])); 
    corr_coeff(j)=corr_coeff1(j)*corr_coeff2(j)*flag(j)*flag2(j);
    if corr_coeff1(j)<0 && corr_coeff2(j)<0
        corr_coeff(j)=-1*corr_coeff(j);
    end
   %index(count) = j;
    %count = count+1;
                
end
%corr_coeff
%index

BIN= (y_peaks(:) < roi/2)+ (x_peaks(:) < roi/2)+(x_peaks(:) > size(img,2)-roi/2)+(y_peaks(:) > size(img,1)-roi/2);
    corr_coeff(find(BIN))=0;
if max(corr_coeff)~=0
   % index = find(abs(corr_coeff)==max(abs(corr_coeff)));

    [corr_coeff_sort,ix]=sort(corr_coeff,'descend');
    if length(corr_coeff)>2
        index(1:3) = ix(1:3);
    elseif length(corr_coeff)==2
        index(1:2)=ix(1:2);
    elseif length(corr_coeff)==1
        index(1)=ix(1);
    end
end

if exist('index')~=1 || isempty(index)
    index=1;
    valid_peak_num=0;
end
ip_y=[NaN; NaN; NaN];
ip_x=[NaN; NaN; NaN];
c=[NaN; NaN; NaN];
if isempty(y_peaks)|| sum(corr_coeff(index))<=0
    ip_y(1)=round(size(img,1)/2);
    ip_x(1)=round(size(img,2)/2);
    c(1)=0;
    valid_peak_num=0;
    
else
    valid_peak_num=length(index);
    ip_y(1:valid_peak_num) = y_peaks(index);
    ip_x(1:valid_peak_num) = x_peaks(index);
    c(1:valid_peak_num)=corr_coeff(index);
end




