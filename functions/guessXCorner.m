function x_cornerGuess = guessXCorner( image,booldotPattern,inversion )
%GUESSXCORNER Summary of this function goes here
%   Detailed explanation goes here
% inversion = true if white marker on black pattern else false
% Invert image if needed
if inversion
    image(:,:,:) = 255-image(:,:,:);
end
Ic = size(image)./2;

if booldotPattern
    I1 = imgaussfilt(image,1);
else
    I1 = image;
end
[x,y,z,c]=imextrema(I1);
saddlePoints = [x(c==0),y(c==0)];
i=numel(saddlePoints)/2;
for k=1:1:i
    X = [Ic;saddlePoints(k,:)];
    distances(k,:)=pdist(X,'euclidean');
end
[Value,Index]=min(distances);
x_cornerGuess=saddlePoints(Index,:);
% figure, imshow(I1),hold on ,plot(x_cornerGuess(1),x_cornerGuess(2),'r.');
end

