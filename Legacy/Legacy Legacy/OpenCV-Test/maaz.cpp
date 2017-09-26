//include section
#include <iostream>
#include <cv.h>
#include <highgui.h>
#include <math.h>
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
using namespace cv;

//finds the angles for shape detection Status: Good to go
double angle( CvPoint* pt1, CvPoint* pt2, CvPoint* pt0 );

//This is for color filtering Status: Doesn't Work Yet
IplImage* GetThresholdedImage(IplImage* imgHSV);

// flag definitions 1: HSV color filtering; 2: Canny Edge Detect; 3: HSV Filter with canny filtering;
////Change these values to get what you need
int flag = 1;


//These values change the HSV filtering values. 
int Hue_Min = 112;
int Hue_Max = 251;

int Saturation_Min = 0;
int Saturation_Max = 256;

int Value_Min = 38;
int Value_Max = 218;


int main()
{
    //Make the windows
    cvNamedWindow("Thresholded",CV_WINDOW_NORMAL);
    cvNamedWindow("Tracked",CV_WINDOW_NORMAL);
    cvNamedWindow("Original",CV_WINDOW_NORMAL);

    //Gets stuff from camera
	CvCapture* capture = cvCaptureFromCAM(0);

	//This variable will hold all the frames. It will hold only one frame on each iteration of the loop. 
	IplImage* frame;

	while(1)
	{
        //Gets Frame from camera
        std::cout << "frame capture\n";
		frame = cvQueryFrame(capture);
        std::cout << "Check\n";

        //puts the original image in the window
        cvShowImage("Original",frame);

        std::cout << "declare imgGrayScale\n";
        IplImage* imgGrayScale;
        std::cout << "check\n";

        //Use the Pyramid thing rob has been working on here
            //
        //cvSmooth( frame, frame, CV_GAUSSIAN, 5, 5 );
            


        if(flag ==1){
        //Filter unwanted colors out
            std::cout << "HSV Flag Active\n";
            std::cout << "HSV Color Filter\n";
            imgGrayScale = GetThresholdedImage(frame);
            std::cout << "Check\n";
        }

        if(flag ==2)
        {
            std::cout << "Grayscale HSV Flag Active\n";
		  //Making a single channel matrix so that edge detection can work properly 
            std::cout << "Grayscale Image\n";
		    imgGrayScale = cvCreateImage(cvGetSize(frame), 8, 1);
			     cvCvtColor(frame,imgGrayScale,CV_BGR2GRAY);
            std::cout << "Check\n";




		// This thresholds the grayscale image to be tested on
        std::cout << "Canny Threshold Image\n";
			//cvThreshold(imgGrayScale,imgGrayScale,100,255,CV_THRESH_BINARY | CV_THRESH_OTSU);  
  	 		cvCanny( imgGrayScale, imgGrayScale, 100, 100, 3 );
        std::cout << "Check\n";
        }
        if(flag == 3)
        {
            std::cout << "HSV Canny Flag Active\n";
            std::cout << "HSV Color Filter\n";
            imgGrayScale = GetThresholdedImage(frame);
            std::cout << "Check\n";
            std::cout << "Canny Threshold Image\n";
            //cvThreshold(imgGrayScale,imgGrayScale,100,255,CV_THRESH_BINARY | CV_THRESH_OTSU);  
            cvCanny( imgGrayScale, imgGrayScale, 100, 100, 3 );
            std::cout << "Check\n";

        }

        std::cout << "Contour Allocation\n";
  	 		CvSeq* contours;  //hold the pointer to a contour in the memory block
 			CvSeq* result;   //hold sequence of points of a contour
 			CvMemStorage *storage = cvCreateMemStorage(0); //storage area for all contours
 			
        std::cout << "Check\n";

        std::cout << "Find Contours\n";
            //finding all contours in the image
 			cvFindContours(imgGrayScale, storage, &contours, sizeof(CvContour), CV_RETR_LIST, CV_CHAIN_APPROX_SIMPLE, cvPoint(0,0));
        std::cout << "Check\n";
 			while(contours){

				//obtain a sequence of points of contour, pointed by the variable 'contour'
     			result = cvApproxPoly(contours, sizeof(CvContour), storage, CV_POLY_APPROX_DP, cvContourPerimeter(contours)*0.02, 0);
   

       			//Triangle Detection 
       			 //if there are 3  vertices  in the contour(It should be a triangle)
    			if(result->total==3 )
     				{
         				//iterating through each point
         				CvPoint *pt[3];
         				for(int i=0;i<3;i++){
             			pt[i] = (CvPoint*)cvGetSeqElem(result, i);
         				}
   						
   						//This If Statement ensures that the edges are sufficiently large enough to be detected
        				if(abs(pt[1]->x - pt[0]->x)>10 && abs(pt[1]->x - pt[2]->x)>10 && abs(pt[2]->x - pt[0]->x)>10){
         					//////////drawing lines around the triangle
         					cvLine(frame, *pt[0], *pt[1], cvScalar(255,0,0),4);
         					cvLine(frame, *pt[1], *pt[2], cvScalar(255,0,0),4);
         					cvLine(frame, *pt[2], *pt[0], cvScalar(255,0,0),4);
         					std::cout << "\nTriangle\n";
       					}
     				}

     			//Rectangle detection
     				//if there are 4 vertices in the contour(It should be a quadrilateral)
     			else if(result->total==4 )
     			{
         				//iterating through each point
         				CvPoint *pt[4];
         				for(int i=0;i<4;i++){
             			pt[i] = (CvPoint*)cvGetSeqElem(result, i);
         				}
        
        		//finding angles
         		double firstAngle = acos(angle( pt[0],pt[2],pt[1] ));
        		double secondAngle = acos(angle(pt[1],pt[3],pt[2]));
         		double thirdAngle = acos(angle(pt[1],pt[3],pt[2]));
         		double fourthAngle = acos(angle(pt[0],pt[2],pt[3]));
         		
         		//This If Statement Ensures that the edges are sufficiently large
         			if(abs(pt[1]->x - pt[0]->x)>10 && abs(pt[1]->x - pt[2]->x)>10 && abs(pt[2]->x - pt[3]->x)>10 && abs(pt[3]->x - pt[0]->x)>10){

         				//This if statement checks the angles to see if its a rectangle or not (90 angles with 10% uncertainty)
            			if(firstAngle <= 1.884 && firstAngle >= 1.308 && secondAngle <= 1.884 && secondAngle >= 1.308 && thirdAngle <= 1.884 && thirdAngle >= 1.308 && fourthAngle <= 1.884 && fourthAngle >= 1.308 )
            				{
         						//drawing lines around the quadrilateral
            					cvLine(frame, *pt[0], *pt[1], cvScalar(0,255,0),4);
            					cvLine(frame, *pt[1], *pt[2], cvScalar(0,255,0),4);
            					cvLine(frame, *pt[2], *pt[3], cvScalar(0,255,0),4);
            					cvLine(frame, *pt[3], *pt[0], cvScalar(0,255,0),4);

            					std::cout << "\nsquare\n" ;
            					//cout << firstAngle; //Uncomment this to get the angles that its detecting. 
            				}
        			}
     			}
                contours = contours->h_next;

 			}
 


		  //Put the images in the frame
 			cvShowImage("Tracked",frame);
            cvShowImage("Thresholded",imgGrayScale);
 		


 			char c = cvWaitKey(33);

 		if(c==27) 
   		 {
        	//cleaning up
        	cvDestroyAllWindows(); 
        	cvReleaseImage(&frame);
        	cvReleaseImage(&imgGrayScale);
        	cvReleaseMemStorage(&storage);
    			break;
   		 }
   		 
   		 //for(int i=1;i<100000000/5;i++);
   		 cvReleaseImage(&imgGrayScale);
         cvReleaseMemStorage(&storage);
         
	}

    return 0;


}

IplImage* GetThresholdedImage(IplImage* imgHSV){
    IplImage* imgThresh=cvCreateImage(cvGetSize(imgHSV),IPL_DEPTH_8U,1);
    cvInRangeS(imgHSV, cvScalar(Hue_Min,Saturation_Min,Value_Min), cvScalar(Hue_Max,Saturation_Max,Value_Max), imgThresh);
    return imgThresh;

}

double angle( CvPoint* pt1, CvPoint* pt2, CvPoint* pt0 )
{
    double dx1 = pt1->x - pt0->x;
    double dy1 = pt1->y - pt0->y;
    double dx2 = pt2->x - pt0->x;
    double dy2 = pt2->y - pt0->y;
    return (dx1*dx2 + dy1*dy2)/sqrt((dx1*dx1 + dy1*dy1)*(dx2*dx2 + dy2*dy2) + 1e-10);
}