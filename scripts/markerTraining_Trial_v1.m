clear;
clc;
cd E:\GitHub\Masters_Work\XML_Files\
addpath('E:\GAC_Files\Positive\');
load('E:\GitHub\Masters_Work\XML_Files\positiveimagelist.mat');
positiveInstances=info(:,1:length(info));
negativeFolder='E:\GAC_Files\Negative\';
trainCascadeObjectDetector('markerDetector.xml',positiveInstances,negativeFolder,...
    'ObjectTrainingSize',[20 20],'NegativeSamplesFactor',2,'FalseAlarmRate',0.1,...
    'TruePositiveRate',0.999,'NumCascadeStages',10,'FeatureType','LBP');

