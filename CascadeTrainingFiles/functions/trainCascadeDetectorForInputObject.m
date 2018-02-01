function trainCascadeDetectorForInputObject( classifierFileName,positiveInstances,negativeFolder,trainingSize,negativeSamplesFactor,falseAlarmRate,truePositiveRate,numOfStages,featureType )
%UNTITLED2 Summary of this function goes here
% This function generates a cascade classifier file for object detection
%   Detailed explanation goes here
trainCascadeObjectDetector(classifierFileName,positiveInstances,negativeFolder,...
    'ObjectTrainingSize',trainingSize,'NegativeSamplesFactor',negativeSamplesFactor,'FalseAlarmRate',falseAlarmRate,...
    'TruePositiveRate',truePositiveRate,'NumCascadeStages',numOfStages,'FeatureType',featureType);

end

