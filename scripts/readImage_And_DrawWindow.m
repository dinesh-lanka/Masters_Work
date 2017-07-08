% Use the initial corner guess from the first image or previous image and
% initially draw a window of size 50-by-50 around the corner guess. Search
% using the marker detection algorithm for the presence of marker in this
% window. If the marker is not present then increase the size of the window
% in 2 or 3 iterations from 60-by-60 to 80-by-80. When the marker is found,
% extract the bounding box coordinates from the marker detection algorithm
% and then use this bounding box as search window and then guess the marker
% corner and send that to the sub-pixel detection.

filePath=['D:\IPCT_Testdaten\Cobra_wing\meas_img\run_30\Cam1\'...
    'Cam1RH_Seq30_11h22m18s725ms_0000.bmp'];
image=imread(filePath);
searchWindowSize=int64(50/2);
[xcornerguess,ycornerguess]=Xcorner_estimator(image);
cornerGuess=[xcornerguess,ycornerguess];
searchWindow=image(xcornerguess-searchWindowSize:xcornerguess+searchWindowSize,...
    ycornerguess-searchWindowSize:ycornerguess+searchWindowSize);
