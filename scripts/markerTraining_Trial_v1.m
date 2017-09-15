clear;
clc;
tic
cd E:\GitHub\Masters_Work\XML_Files\
addpath('E:\GAC_Files\Markers\Markers_Any_Background\Positive\');
load('E:\GitHub\Masters_Work\XML_Files\positiveImageListMarkersAnyBackground.mat');
positiveInstances=info(:,1:length(info));
negativeFolder='E:\GAC_Files\Markers\Markers_With_White_Backgrounds\Negative_Images\';
trainCascadeObjectDetector('markerDetectorAnyBackground.xml',positiveInstances,negativeFolder,...
    'ObjectTrainingSize',[20 20],'NegativeSamplesFactor',10,'FalseAlarmRate',0.1,...
    'TruePositiveRate',0.999,'NumCascadeStages',20,'FeatureType','LBP');
toc
