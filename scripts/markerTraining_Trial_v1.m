clear;
clc;
cd C:\Users\JAI\Desktop\Markers\XML_Lists\
addpath('C:\Users\JAI\Desktop\Markers\Positive\');
load('C:\Users\JAI\Desktop\Markers\XML_Lists\positiveImageList.mat');
positiveInstances=info(:,1:length(info));
negativeFolder='C:\Users\JAI\Desktop\Markers\Negative\';
trainCascadeObjectDetector('markerDetector.xml',positiveInstances,negativeFolder,...
    'ObjectTrainingSize',[20 20],'NegativeSamplesFactor',2,'FalseAlarmRate',0.1,...
    'TruePositiveRate',0.999,'NumCascadeStages',10,'FeatureType','LBP');

