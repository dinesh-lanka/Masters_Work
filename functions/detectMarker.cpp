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
Mat subImage;
CascadeClassifier detect_marker, detect_xCorner;
vector<Rect> boxes, xcornerBoxes;
//The function that detects the marker using Cascade Object Detection
int cascadeDetector(const Mat& images,char* xmlfilepath,char* xcornerXMLfilepath,int argumentsCount,double* pointer2data, int& x, const int& y) {
    //If the input arguments are sufficient then only it proceeds with detection
    if (argumentsCount > 1)
    {
        /*imshow("Image",images);
         * waitKey(0);*/        
        detect_marker.load(xmlfilepath);
        detect_xCorner.load(xcornerXMLfilepath);
        
        //Detecting the markers on the image provided and storing these in the boxes vector of type rectangle
        detect_marker.detectMultiScale(images, boxes, 1.1, 3, 0, Size(10, 10), Size(x, x));
        
        Rect *p = boxes.data();
        //Condition that allows only one object detection
        if ((boxes.size() == 1) && (images.rows >= 10) && (images.rows >= 10))
        {
            pointer2data[0] = p->x;
            pointer2data[1] = p->y;  
            pointer2data[2] = p->width;
            pointer2data[3] = p->height;
            
            //Detecting xcorners from marker image
            if ((p->x>=0) && (p->width >=0) && ((p->x + p->width) <= images.cols) && (p->y>=0) && (p->height >=0) && ((p->y + p->height) <= images.rows))
            {
                Rect roi(p->x, p->y, p->width, p->height);
                
                subImage = images(roi);
                /*imshow("subimage",subImage);
                 * waitKey(0);*/
                detect_xCorner.detectMultiScale(subImage, xcornerBoxes, 1.1, 3, 0);
                if ((xcornerBoxes.size()==1))
                {
                    Rect *p2 = xcornerBoxes.data();
                    if ((p2->x>0) && (p2->y>0) && (p2->width>0) && (p2->height>0) && ((p2->x + p2->width) <= images.cols) && ((p2->y + p2->height)<= images.rows))
                    {
                        pointer2data[4] = p2->x;
                        pointer2data[5] = p2->y;
                        pointer2data[6] = p2->width;
                        pointer2data[7] = p2->height;
                    }
                }
            }
        }
        
        else
        {
            pointer2data[0] = -1;
            //system("pause");
        }
    }
    else
    {
        pointer2data[0] = -1;
    }
    return 1;
}

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[]){
    if (nrhs < 5) {
        mexErrMsgTxt("Insufficient input arguments.");
    }
    if(!mxIsClass(prhs[0], "uint8"))
    {
        mexErrMsgTxt("Only image arrays of the UINT8 class are allowed.");
        return;
    }
    
    uint8* rgb = (uint8*) mxGetPr(prhs[0]);
    int* dims = (int*) mxGetDimensions(prhs[0]);
    
    int height = dims[0];
    int width = dims[1];
    int imsize = height * width;
    int maxSize = (int)*mxGetPr(prhs[3]);
    int minSize = (int)*mxGetPr(prhs[4]);
    
    Mat Red(1, imsize, DataType<uint8>::type, rgb);
    Mat Green(1, imsize, DataType<uint8>::type, rgb+imsize);
    Mat Blue(1, imsize, DataType<uint8>::type, rgb+imsize + imsize);
    
    // Opencv is BGR and matlab is column-major order
    Mat image[3];
    image[2] = Red.reshape(1,width).t();
    image[1] = Green.reshape(1,width).t();
    image[0] = Blue.reshape(1,width).t();
    
    // Converted to OpenCV Mat type
    Mat imageCV;
    merge(image,3,imageCV);
//     imshow("a",imageCV);
    
    char* xmlfilepath = mxArrayToString(prhs[1]);
    char* xcornerXMLfilepath = mxArrayToString(prhs[2]);
    plhs[0] = mxCreateNumericMatrix(1, 8, mxDOUBLE_CLASS, mxREAL);
    double* data = (double*) mxGetData(plhs[0]);
    cascadeDetector(imageCV,xmlfilepath,xcornerXMLfilepath,nrhs,data,maxSize,minSize);
    return;
}