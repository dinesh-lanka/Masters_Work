// This MEX function returns the size of marker at each initial cps values
#include "mex.h"
#include <stdio.h>
#include <iostream>
#include <fstream>
#include "opencv2\objdetect\objdetect.hpp"
#include "opencv2\opencv.hpp"

using namespace std;
using namespace cv;

Mat image, imageSegment;
CascadeClassifier detect_marker;
vector<Rect>boxes;
double a, b;

int marker_size_at_cps(char* imagefilepath, char* xmlfilepath, char* imagecpsfilepath,const int& maxSize,const int& minSize, int& numberOfCPS, double* pointer2data)
{
    static int i = 0;
    const int x = maxSize+10;
    image = imread(imagefilepath, IMREAD_GRAYSCALE);
    detect_marker.load(xmlfilepath);
    ifstream infile(imagecpsfilepath);
// Reading the initial cps points
    while (infile >> a >> b)
    {
        Rect roi((int)a - (maxSize / 2), (int)b - (maxSize / 2), maxSize, maxSize);
        if (roi.x<0) { roi.x = 0; }
        if (roi.y<0) { roi.y = 0; }
        if (roi.x+roi.width>image.cols) { roi.width = image.cols-roi.x; }
        if (roi.y+roi.height>image.rows) { roi.height = image.rows-roi.y; }
        imageSegment = image(roi);
// Detecting marker and returning its size value
        detect_marker.detectMultiScale(imageSegment, boxes, 1.1, 3, 0, Size(10, 10), Size(x, x));
        if (boxes.size()==1)
        {
            for (vector<Rect>::iterator r = boxes.begin(); r != boxes.end(); ++r)
            {
                Rect detectedObjectBoundary = (*r);
                if (detectedObjectBoundary.width >= detectedObjectBoundary.height)
                {
                    pointer2data[i] = detectedObjectBoundary.width;
                    i++;
                }
                else
                {
                    pointer2data[i] = detectedObjectBoundary.height;
                    i++;
                }
            }
        }
// If marker is not detected then we assume the size as mean of the maximum and minimum value of marker size
        else
        {
            pointer2data[i] = (int)(maxSize+minSize)/2;
            i++;
        }
    }
    infile.close();
    i=0;
    return 1;
}

/*List of input arguments
 *absolute filepath of image from camera
 *marker detection classifier absolute path
 *initial image cps absolute filepath
 *maximum and  minimum marker sizes for image from camera 1
 *number of cps points in the image
 */
void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
    
    if (nrhs < 6)
    {
        mexErrMsgTxt("Insufficient input arguments. Please enter the arguments like this:\nget_MarkerSize_AtCPS(<Image absolute path>,<Marker Classifier Path>,<Image CPS Path>,<Image maximum marker size>,<Image minimum marker size>,<Number of initial cps>");
    }
    char* imagefilepath = mxArrayToString(prhs[0]);
    char* xmlfilepath = mxArrayToString(prhs[1]);
    char* imagecpsfilepath = mxArrayToString(prhs[2]);
    int maxSize = (int)*mxGetPr(prhs[3]);
    int minSize = (int)*mxGetPr(prhs[4]);
    int numberOfCPS = (int)*mxGetPr(prhs[5]);
    plhs[0] = mxCreateNumericMatrix(1, numberOfCPS, mxDOUBLE_CLASS, mxREAL);
    double* data = (double*) mxGetData(plhs[0]);
    marker_size_at_cps(imagefilepath,xmlfilepath,imagecpsfilepath,maxSize,minSize,numberOfCPS,data);
    return;
}
