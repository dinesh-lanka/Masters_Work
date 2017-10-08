close all; clear; clc;
I = imread('E:\GAC_Files\Markers\SVMTraining\blackMarker\MarkerWhiteBG_PI_00000066.PNG');
%Read Background Image
Background=rgb2gray(imread('E:\GAC_Files\Markers\Markers_Any_Background\Background\Capture.png'));
tic
Background=imresize(Background,[100 100]);
%Read Current Frame
CurrentFrame=I;
%Display Background and Foreground
subplot(2,2,1);imshow(Background);title('BackGround');
subplot(2,2,2);imshow(CurrentFrame);title('Current Frame');
%Convert RGB 2 HSV Color conversion
Background=cat(3,Background,Background,Background);
[Background_hsv]=round(rgb2hsv(Background));
[CurrentFrame_hsv]=round(rgb2hsv(CurrentFrame));
Out = bitxor(Background_hsv,CurrentFrame_hsv);
%Convert RGB 2 GRAY
Out=rgb2gray(Out);
%Read Rows and Columns of the Image
[rows columns]=size(Out);
%Convert to Binary Image
for i=1:rows
    for j=1:columns
        
        if Out(i,j) >0            
            BinaryImage(i,j)=1;            
        else            
            BinaryImage(i,j)=0;            
        end        
    end
end

%Apply Median filter to remove Noise
FilteredImage=medfilt2(BinaryImage,[5 5]);

%Boundary Label the Filtered Image
[L num]=bwlabel(FilteredImage);

STATS=regionprops(L,'all');
cc=[];
removed=0;

%Remove the noisy regions
for i=1:num
    dd=STATS(i).Area;
    
    if (dd < 500)
        
        L(L==i)=0;
        removed = removed + 1;
        num=num-1;        
    else        
    end
    
end

[L2 num2]=bwlabel(L);

% Trace region boundaries in a binary image.
[B,L,N,A] = bwboundaries(L2);

%Display results
subplot(2,2,3),  imshow(L2);title('BackGround Detected');
subplot(2,2,4),  imshow(L2);title('Blob Detected');

hold on;
for k=1:length(B)    
    if(~sum(A(k,:)))
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);        
        for l=find(A(:,k))'
            boundary = B{l};
            plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
        end        
    end    
end
toc




%
% %% CONSTANTS
% count = 0;
% laplace_matrix = fspecial('laplacian');
% %N IS GIVEN AN ARBITRARY VALUE GREATER THAN 10 SO THAT WE CAN ENTER THE WHILE LOOP
% n = 11;
%
% %% IMAGE INPUT
% img = I;
% img = img(:,:,1);
% pyr_down_img = img; %% HOLDS THE CURRENT PYRAMID LEVEL PICTURE
%
% %% PYRDOWN ALGORITHM AND SPOT DETECTION
% %RUN THE LOOP TILL LESS THAT 10 GOOD SPOTS ARE PRESENT
% while(n > 10)
%
% % COUNTS THE LEVEL OF THE PYRAMID AND FINALLY HAS THE HEIGHT
% count = count + 1
% pyr_down_img = impyramid(pyr_down_img,'reduce');
% % EDGE DETECTOR TO FIND THE SPOTS
% Spot_img = imfilter(pyr_down_img,laplace_matrix);
% n = 0;
% [M N] = size(Spot_img);
% for i = 1:M
% for j = 1:N
% if(Spot_img(i,j) >= 0.6*max(max(Spot_img))) % FINDING PROMINANT SPOTS
%
% %SAVE THE No. OF SPOTS IN n , COMPARE n TO SEE IF THE WHILE LOOP SHOULD CONTINUE
% n = n+1;
% end
% end
% end
% end % END OF WHILE LOOP
% imshow(pyr_down_img);
%
% %% FINDING THE BEST (BRIGHTEST) SPOT
% figure,imshow(Spot_img,[]);
% [M N] = size(Spot_img);
% for i = 1:M
% for j = 1:N
% if(Spot_img(i,j) == max(max(Spot_img)))
% x_cord = i;
% y_cord = j;
% end
% end
% end
%
% %% FINDING THAT SPOT ON THE ORIGINAL IMAGE, WE TRY TO FIND A REGION IN
% %%WHICH THE OBJECT MIGHT BE PRESENT
%
% [M N] = size(img); % SIZE OF ORIGINAL IMAGE
%
% % IF THE CALCULATED PIXEL IS OUT OF BOUND,USE THE SIZE VALUE OF %IMAGE
% orig_x = min([x_cord*(2^count),M]);
% orig_y = min([y_cord*(2^count),N]);
% top_left_x = orig_x - ((2^(count-1))-1);
% top_left_y = orig_y - ((2^(count-1))-1) ;
%
% % ESTIMATED REGION IN WHICH OBJECT MAY BE PRESENT
% ROI = img(top_left_x:orig_x,top_left_y:orig_y);
%
% %% INITIAL ESTIMATE FOR THE THRESHOLD IS AVERAGE OF THE GREYSCALE VALUES IN THE ROI
% initial_estimate_thresh = uint8(mean(ROI(:)));
% background_estimate = uint8(mean(img(:)));
%
% %% DEPENDING UPON THE KIND OF OBJECT AND BACKGROUNG , THE INITIAL OR BACKGROUND ESTIMATE MAY BE HIGHER THAN THE OTHER
% %%HERE IS A METHOD TO MAKE THE CODE WORK IN BOTH THE CONDITIONS
% upper_level = max([initial_estimate_thresh, background_estimate]);
% lower_level = min([initial_estimate_thresh, background_estimate]);
%
% %CAN'T LET ANY INDEX BE ZERO
% lower_level = max([lower_level,1]);
%
% %% ACCEPTING THE HISTOGRAM VALUES OF THE IMAGE IN AN ARRAY AND
% %%SLICING IT IN THE TWO THRESHOLD RANGES
% plot_array = imhist(img);
% plot_array = plot_array(lower_level:upper_level);
% plot(plot_array);
%
% % THE LOWEST VALLEY CORRESPONDS TO THE THRESHOLD VALUE
% [amount thresh_value] = min(plot_array);
%
% %% FINAL THRESH VALUE IS
% thresh = lower_level + thresh_value;
%
% %% COMPLETE THRESHOLD OF THE IMAGE
% thresh_img = zeros(M,N);
% for i = 1:M
% for j = 1:N
% if(img(i,j) >= thresh)
% thresh_img(i,j) = 0;
% else thresh_img(i,j) = 255;
% end
% end
% end
% figure,imshow(thresh_img,[]);