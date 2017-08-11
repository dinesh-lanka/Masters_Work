clear;
clc;
tic
cd E:\GitHub\Masters_Work\XML_Files\
addpath('E:\GAC_Files\Markers\Markers_With_White_Backgrounds\Positive_Images\');
load('E:\GitHub\Masters_Work\XML_Files\positiveImageListMarkersWithWhiteBG.mat');
positiveInstances=info(:,1:length(info));
negativeFolder='E:\GAC_Files\Markers\Markers_With_White_Backgrounds\Negative_Images\';
trainCascadeObjectDetector('markerDetectorWhiteBG.xml',positiveInstances,negativeFolder,...
    'ObjectTrainingSize',[20 20],'NegativeSamplesFactor',3,'FalseAlarmRate',0.2,...
    'TruePositiveRate',0.999,'NumCascadeStages',20,'FeatureType','LBP');
toc
