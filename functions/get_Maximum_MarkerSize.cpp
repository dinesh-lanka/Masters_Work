/*This is a mex file for usig OpenCV functions in MATLAB. It detects the
 *marker position and returns the bounding boxes values to MATLAB calling
 * fucntion.
 */
#include <stdio.h>
#include <iostream>
#include "opencv2\objdetect\objdetect.hpp"
#include "opencv2\opencv.hpp"
#include "mex.h"
#define uint8 unsigned char

using namespace std;
using namespace cv;

CascadeClassifier detect_marker;
vector<Rect> boxes,boxes2;
const int x = 100;
Mat image,image2;
//The function that detects the marker using Cascade Object Detection
int marker_MaximumSize(char* imagefilepath,char* imagefilepath2,char* xmlfilepath,int argumentsCount,double* pointer2data)
{
    //If the input arguments are sufficient then only it proceeds with detection
    if (argumentsCount > 2)
    {
        int flag = 0, minFlag = 25, flag2 = 0, minFlag2 = 25;
        image = imread(imagefilepath,IMREAD_ANYDEPTH);
        image2 = imread(imagefilepath2,IMREAD_ANYDEPTH);
        detect_marker.load(xmlfilepath);
        //Detecting the markers on the image provided and storing these in the boxes vector of type rectangle
        detect_marker.detectMultiScale(image, boxes, 1.1, 3, 0, Size(10, 10), Size(x, x));        
        //Condition that allows only one object detection
        if ((boxes.size() > 1) && (image.rows >= 10) && (image.cols >= 10))
        {
            for (vector<Rect>::iterator r = boxes.begin(); r != boxes.end(); ++r)
            {
                flag = ((r->width) > flag) ? (r->width) : flag;
                minFlag = ((r->width) < minFlag) ? (r->width) : minFlag;
                pointer2data[0]=flag;
                pointer2data[1]=minFlag;
            }
        }
        detect_marker.detectMultiScale(image2, boxes2, 1.1, 3, 0, Size(10, 10), Size(x, x));
        if ((boxes2.size() > 1) && (image2.rows >= 10) && (image2.cols >= 10))
        {
            for (vector<Rect>::iterator c = boxes2.begin(); c != boxes2.end(); ++c)
            {
                flag2 = ((c->width) > flag2) ? (c->width) : flag2;
                minFlag2 = ((c->width) < minFlag2) ? (c->width) : minFlag2;
                pointer2data[2]=flag2;
                pointer2data[3]=minFlag2;
            }
        }
        return 1;
    }
    else
    {
        mexErrMsgTxt("Insufficient input arguments.");
        return -1;
    }
}

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
    if (nrhs < 2) {
        mexErrMsgTxt("Insufficient input arguments. Please enter the arguments like this:\nget_Maximum_MarkerSize(<Image absolute path>,<Image absolute path>,<Marker Classifier Path>)");
    }
    
    char* imagefilepath = mxArrayToString(prhs[0]);
    char* imagefilepath2 = mxArrayToString(prhs[1]);
    char* xmlfilepath = mxArrayToString(prhs[2]);
    plhs[0] = mxCreateNumericMatrix(1, 4, mxDOUBLE_CLASS, mxREAL);
    double* data = (double*) mxGetData(plhs[0]);
    marker_MaximumSize(imagefilepath,imagefilepath2,xmlfilepath,nrhs,data);
    return;
}