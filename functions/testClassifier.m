function testClassifier( cascadeDetectorFile,imageFile )
%This function is used to test a newly developed classifier file. It takes
%two inputs: The classifier file and the image file
% The function must be run as "testClassifier cascadeDetectorFile
% imageFile" in the command prompt without the double quotes
if nargin < 2
    disp('Insufficient input arguments');
    disp('Arguments List and Description');
    disp('This function takes arguments in this order - cascadeDetectorFile,imageFile');
    disp('cascadeDetectorFile: The absolute path of the cascade classifier xml file');
    disp('imageFile: The absolute path of image file');    
else    
    detector = vision.CascadeObjectDetector(cascadeDetectorFile);
    I = imread(imageFile);
    box = step(detector,I);
    detectedImg = insertObjectAnnotation(I,'rectangle',box, 'Marker');
    figure, imshow(detectedImg);
end
end

