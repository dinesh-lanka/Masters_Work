function cascadeTraining( positiveImageList,classifierDestinationPath,positiveImagesFolderPath,backgroundImagesFolderPath,numOfStages,classifierFileName,...
    negativeSamplesFactor, objectTrainingSize, falseAlarmRate, truePositiveRate, featureType )
% cascadeTraining function creates a classifier file for detecting objects.
% This function takes arguments in this order - positiveImageList,classifierDestinationPath,positiveImagesFolderPath,backgroundImagesFolderPath,numOfStages,classifierFileName,negativeSamplesFactor,objectTrainingSize, falseAlarmRate, truePositiveRate, featureType
% classifierDestinationPath: The absolute path of the folder to which the generated object classifier must be saved
% classifierFileName: The name of the generated object classifier file (without any spaces and special characters).
% backgroundImagesFolderPath: The absolute path of background or non-object image files.
% falseAlarmRate: The false alarm rate is the fraction of negative training samples incorrectly classified as positive samples and it is a value in the range (0 1]. A value of 0.1 would yield less false detections.
% featureType: Feature descriptor for the object - Haar, HOG, LBP.
% numOfStages: Number of cascade stages to train and it is a positive integer. Increasing the number of stages may result in a more accurate detector but also increases training time. More stages can require more training images, because at each stage, some number of positive and negative samples are eliminated.
% negativeSamplesFactor: The number of negative samples to use at each stage for each positive sample.
% objectTrainingSize: The size to which the image must be reduced in order to improve the training time and it is a positive integer.
% positiveImagesFolderPath: The absolute path of object or positive samples (image) files.
% positiveImageList: List of Positive Samples arranged into a mat file consisting of a structure "info" with two fields. The first field (column) is named "imageFilename" and consists of the absolute path of positive image file and the second field is "objectBoundingBoxes" and consists of a row array with details of a rectangle bounding the object under interest and its size, in the order (x,y,w,h).
% truePositiveRate: The true positive rate is the fraction of correctly classified positive training samples and and it is a value in the range (0 1]. A value of 0.999 would yield a calssifier with higher true positive detection rates.
if nargin < 11
    disp('Insufficient input arguments');
    disp('Arguments List and Description');
    disp('This function takes arguments in this order - positiveImageList,classifierDestinationPath,positiveImagesFolderPath,backgroundImagesFolderPath,numOfStages,classifierFileName,negativeSamplesFactor,objectTrainingSize, falseAlarmRate, truePositiveRate, featureType');
    disp('classifierDestinationPath: The absolute path of the folder to which the generated object classifier must be saved');
    disp('classifierFileName: The name of the generated object classifier file (without any spaces and special characters).');
    disp('backgroundImagesFolderPath: The absolute path of background or non-object image files.');
    disp('falseAlarmRate: The false alarm rate is the fraction of negative training samples incorrectly classified as positive samples and it is a value in the range (0 1]. A value of 0.1 would yield less false detections.');
    disp('featureType: Feature descriptor for the object - Haar, HOG, LBP.');
    disp('numOfStages: Number of cascade stages to train and it is a positive integer. Increasing the number of stages may result in a more accurate detector but also increases training time. More stages can require more training images, because at each stage, some number of positive and negative samples are eliminated.');
    disp('negativeSamplesFactor: The number of negative samples to use at each stage for each positive sample.');
    disp('objectTrainingSize: The size to which the image must be reduced in order to improve the training time and it is a positive integer.');
    disp('positiveImagesFolderPath: The absolute path of object or positive samples (image) files.');
    disp('positiveImageList: List of Positive Samples arranged into a mat file consisting of a structure "info" with two fields. The first field (column) is named "imageFilename" and consists of the absolute path of positive image file and the second field is "objectBoundingBoxes" and consists of a row array with details of a rectangle bounding the object under interest and its size, in the order (x,y,w,h). ');
    disp('truePositiveRate: The true positive rate is the fraction of correctly classified positive training samples and and it is a value in the range(0 1]. A value of 0.999 would yield a calssifier with higher true positive detection rates.');
else
    
    [~, status] = str2num(objectTrainingSize);
    if status
        objectTrainingSize = str2double(objectTrainingSize);
        trainingSize = [objectTrainingSize objectTrainingSize];
    else
        trainingSize = 'Auto';
    end
    % Adding the .xml extension to classifier file name
    classifierFileName = [classifierFileName '.xml'];
    
    % Change path to the destination path for writing the classifier file
    cd(classifierDestinationPath);
    
    % Selecting the positive images folder path
    addpath(fullfile(positiveImagesFolderPath));
    
    % loading positive image list
    load(positiveImageList);
    
    % Selecting the background images folder path
    negativeFolder=fullfile(backgroundImagesFolderPath);
    
    % Selecting postive instances
    positiveInstances=info(:,1:length(info));
    
    % Training the cascade classifier with the inbuilt MATLAB function
    % trainCascadeDetectorForInputObject( classifierFileName,positiveInstances,negativeFolder,trainingSize,negativeSamplesFactor,falseAlarmRate,truePositiveRate,numOfStages,featureType );
    trainCascadeObjectDetector(classifierFileName,positiveInstances,negativeFolder,...
        'ObjectTrainingSize',trainingSize,'NegativeSamplesFactor',negativeSamplesFactor,'FalseAlarmRate',falseAlarmRate,...
        'TruePositiveRate',truePositiveRate,'NumCascadeStages',numOfStages,'FeatureType',featureType);
end
end

