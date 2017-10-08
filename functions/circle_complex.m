function varargout = circle_complex(varargin)
%makes a cirlce with input parameters:
%   xc = x-coordinate of center
%   yc = y-coordinate of center
%   r = radius of the circle
%   (numofpoints = number of points on the circle, optional)
%
%returnes the dot coordinates of the circle:
%   output(1) = x; 
%   output(2) = y; 
%   output(3) = z; 
%
%Thorsten Weikert, DLR, 2012

xc = varargin{1}; %centerpoint_x
yc = varargin{2}; %centerpoint_y
r = varargin{3}; %radius


if nargin > 3
    numofpoints = varargin{4}; %number of stützstellen
else
    numofpoints = 4*r - 4;
end

count = 1;

for phi = 0 : 2*pi/numofpoints : 2*pi-2*pi/numofpoints
    
    %phi = cos(b);
    z(count) = round(r*exp(i*phi));
    
    x(count) = real(z(count));
    y(count) = imag(z(count));
    
    count = count+1;
    
end

varargout{1} = x+xc;
varargout{2} = y+yc;
varargout{3} = z;

