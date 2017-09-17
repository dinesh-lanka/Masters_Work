function cascadeTraining( positiveImageList,classifierDestinationPath,positiveImagesFolderPath,backgroundImagesFolderPath,numOfStages,classifierFileName,negativeSamplesFactor)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
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

classifierFileName = [classifierFileName '.xml'];
% Training the cascade classifier
trainCascadeObjectDetector(classifierFileName,positiveInstances,negativeFolder,...
    'ObjectTrainingSize',[20 20],'NegativeSamplesFactor',negativeSamplesFactor,'FalseAlarmRate',0.1,...
    'TruePositiveRate',0.999,'NumCascadeStages',numOfStages,'FeatureType','LBP');

end

