function [xcornerguess,ycornerguess] = Xcorner_estimator(image)
%XCORNER_ESTIMATOR Summary of this function goes here
%   Detailed explanation goes here
% I=im2double(imadjust(rgb2gray(image)));
% I=im2double(imadjust(rgb2gray(image)));
I=im2double(imadjust(image));
sigma=5;
x=-30:0.5:30;
y=x;
[X,Y]=meshgrid(x,y);

Ic=(medfilt2(I));
figure, imshow(Ic);

g = 1/(2*pi*sigma^2).*exp((-(X.^2+Y.^2)./(2*sigma^2)));
g_x = -X./(2*pi*sigma^4).*exp((-(X.^2+Y.^2)./(2*sigma^2)));
g_y = -Y./(2*pi*sigma^4).*exp((-(X.^2+Y.^2)./(2*sigma^2)));
g_xx = (-1/(2*pi*sigma^4) + X.^2./(2*pi*sigma^6)).*exp((-(X.^2+Y.^2)./(2*sigma^2)));
g_yy = (-1/(2*pi*sigma^4) + Y.^2./(2*pi*sigma^6)).*exp((-(X.^2+Y.^2)./(2*sigma^2)));
g_xy = X.*Y./(2*pi*sigma^6).*exp((-(X.^2+Y.^2)./(2*sigma^2)));

ry = conv2(Ic,g_y,'same');
ryy = conv2(Ic,g_yy,'same');
rx = conv2(Ic,g_x,'same');
rxx = conv2(Ic,g_xx,'same');
ryx = conv2(Ic,g_xy,'same');
S = (rxx.*ryy)-(ryx.^2);
t = (ry.*ryx-rx.*ryy)./S;
s = (rx.*ryx-ry.*rxx)./S;

[value,valueindex]=min(S);
[value2,value2index]=min(value);
sizeI=size(S);

for i=1:sizeI(1,1)
    if(S(i,value2index)==value2)
        location=i;
        break;
    end
end

position=[location,value2index];
subS= s(position(1,1),position(1,2));
subT=t(position(1,1),position(1,2));
xcornerguess=position(1,2)+subS;
ycornerguess=position(1,1)+subT;

end

