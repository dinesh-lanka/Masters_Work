function r = corr2_own(varargin)
%CORR2 Compute 2-D correlation coefficient.
%   R = CORR2(A,B) computes the correlation coefficient between A
%   and B, where A and B are matrices or vectors of the same size.
%
%   Class Support
%   -------------
%   A and B can be numeric or logical. 
%   R is a scalar double.
%
%   Example
%   -------
%   I = imread('pout.tif');
%   J = medfilt2(I);
%   R = corr2(I,J)
%
%   See also CORRCOEF, STD2.

%   Copyright 1992-2003 The MathWorks, Inc.
%   $Revision: 5.18.4.3 $  $Date: 2004/08/10 01:39:00 $

[a,b] = ParseInputs(varargin{:});

a = a - mean2(a);
b = b - mean2(b);



if sum(sum(a.*a)) ~= 0 && sum(sum(b.*b))~= 0
    %corrcoeff:
    r = sum(sum(a.*b))/sqrt(sum(sum(a.*a))*sum(sum(b.*b)));
else
    r = 0;
end
%--------------------------------------------------------
function [A,B] = ParseInputs(varargin)

[v d]=version;
clear d;
v_num = str2num(v(1));

if v_num > 7
    narginchk(2,2);
else
    iptchecknargin(2,2,nargin, mfilename);
end

A = varargin{1};
B = varargin{2};

if v_num > 7
    validateattributes(A, {'logical' 'numeric'}, {'real'}, mfilename, 'A', 1);
    validateattributes(B, {'logical' 'numeric'}, {'real'}, mfilename, 'B', 2);
    if any(size(A)~=size(B))
        error(message('images:corr2:notSameSize'))
    end
else
    iptcheckinput(A, {'logical' 'numeric'}, {'real'}, mfilename, 'A', 1);
    iptcheckinput(B, {'logical' 'numeric'}, {'real'}, mfilename, 'B', 2);
    if any(size(A)~=size(B))
        messageId = 'Images:corr2:notSameSize';
        message1 = 'A and B must be the same size.';
        error(messageId, '%s', message1);
    end
end


if (~isa(A,'double'))
    A = double(A);
end

if (~isa(B,'double'))
    B = double(B);
end










