//include section
#define LEFT 67
#define RIGHT 68
#define SPACE 32
#define LCLICK 6
#define RCLICK 7
#include <iostream>
#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <math.h>
#include <string>
#include <windows.h>
#include <sstream>
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/core/core.hpp"

using namespace cv;
using namespace std;

//finds the angles for shape detection Status: Good to go
double angle( CvPoint* pt1, CvPoint* pt2, CvPoint* pt0 );

//This is for color filtering Status: Doesn't Work Yet
IplImage* GetThresholdedImage(IplImage* imgHSV);
CvPoint* createPoint(int xc, int yc);
vector<string> split(const std::string &s, char delim);
// flag definitions 1: HSV color filtering; 2: Canny Edge Detect; 3: HSV Filter with canny filtering;
////Change these values to get what you need
int flag = 2;


//These values change the HSV filtering values.
int Hue_Min = 112;
int Hue_Max = 251;

int Saturation_Min = 0;
int Saturation_Max = 256;

int Value_Min = 38;
int Value_Max = 218;

CvPoint* mousePos=new CvPoint();
int mouseEvent=0;
void onMouse(int event, int x, int y, int, void*);
int autoImages=0;
int manualImages=0;
int keyEvent=0;
bool first = true;
int main()
{
    //Make the windows
    //cvNamedWindow("Thresholded",CV_WINDOW_NORMAL);
    cvNamedWindow("Tracked",CV_WINDOW_NORMAL);
    //cvNamedWindow("Original",CV_WINDOW_NORMAL);
    //cvNamedWindow("Helper",CV_WINDOW_NORMAL);
    cvSetMouseCallback("Tracked",onMouse,NULL);
    //Gets stuff from camera
    release:
	CvCapture* capture = cvCaptureFromCAM(1);
    cvReleaseCapture(&capture);
    capture = cvCaptureFromCAM(0);
        cout<<cvQueryFrame(capture);
        //CvCapture* capture = cvCaptureFromFile("C:\\Users\\James\\Desktop\\OpenCV\\Videos\\poor quality 6-12-14.mp4");
        if(!capture)
        {
            printf("ack\n");
            return -1;
        }
	//This variable will hold all the frames. It will hold only one frame on each iteration of the loop.
	IplImage* frameHelp=NULL;
        IplImage* frame;
	while(1)
	{
        //Mouse input
        if(!first)
        switch(mouseEvent)
        {
            case 0:
                break;
            case 6:
            {
                mouseEvent=0;

                manualImages++;
                SYSTEMTIME str_t;
                GetSystemTime(&str_t);
                ostringstream newManual;
                int hours=str_t.wHour-4;
                if(hours<0)
                    hours+=24;
                newManual<<"C:\\Users\\James\\Desktop\\IMAGES\\target"<<manualImages<<".jpg";
                string helperString=newManual.str();
                const char* manCount= helperString.c_str();

                CvFont fondue;
                cvInitFont(&fondue,CV_FONT_HERSHEY_SIMPLEX ,.5,.5,.5,1,8);
                // text box is 500x200 pixels
                cvRectangle(frame,*createPoint(0,0),*createPoint(500,200),cvScalar(0,0,0),CV_FILLED,8,0);
                cvPutText(frame,"Target Shape: ",*createPoint(20,35),&fondue,cvScalar(255,255,255));
                cvPutText(frame,"Target Color: ",*createPoint(20,85),&fondue,cvScalar(255,255,255));
                cvPutText(frame,"Letter: ",*createPoint(20,135),&fondue,cvScalar(255,255,255));
                cvPutText(frame,"Letter Color: ",*createPoint(20,185),&fondue,cvScalar(255,255,255));

                cvRectangle(frame,*createPoint(200,10),*createPoint(500,40),cvScalar(255,255,255),4,8,0);
                cvRectangle(frame,*createPoint(200,60),*createPoint(500,90),cvScalar(255,255,255),4,8,0);
                cvRectangle(frame,*createPoint(200,110),*createPoint(500,140),cvScalar(255,255,255),4,8,0);
                cvRectangle(frame,*createPoint(200,160),*createPoint(500,190),cvScalar(255,255,255),4,8,0);
                cvShowImage("Tracked",frame);
                //draw box to frame

                int enters=0;
                CvPoint* cursPos = new CvPoint();
                cursPos->x=210;
                cursPos->y=16;
                CvSize* textSize=new CvSize();
                int baseline=0;
                cvGetTextSize("Cy", &fondue, textSize,&baseline);
                cvRectangle(frame,*cursPos,*createPoint(cursPos->x+textSize->width/2,cursPos->y+18),cvScalar(255,255,255),CV_FILLED,8,0);
                //loop and take input from keyboard with cvWaitKey(0), drawing it every time

                while(true)
                {
                    char cherry=cvWaitKey(0);
                    if((int)cherry==13)
                    {
                        enters++;
                        switch(enters)
                        {
                            case 1:
                            {
                                cvRectangle(frame,*cursPos,*createPoint(cursPos->x+textSize->width/2,cursPos->y+18),cvScalar(0,0,0),CV_FILLED,8,0);
                                cursPos->x=210;
                                cursPos->y=66;
                                break;
                            }
                            case 2:
                            {
                                cvRectangle(frame,*cursPos,*createPoint(cursPos->x+textSize->width/2,cursPos->y+18),cvScalar(0,0,0),CV_FILLED,8,0);
                                cursPos->x=210;
                                cursPos->y=116;
                                break;
                            }
                            case 3:
                            {
                                cvRectangle(frame,*cursPos,*createPoint(cursPos->x+textSize->width/2,cursPos->y+18),cvScalar(0,0,0),CV_FILLED,8,0);
                                cursPos->x=210;
                                cursPos->y=166;
                                break;
                            }
                            case 4:
                            {
                                cvRectangle(frame,*cursPos,*createPoint(cursPos->x+textSize->width/2,cursPos->y+18),cvScalar(0,0,0),CV_FILLED,8,0);
                                goto ImaLabelXD;
                            }
                        }
                    }
                    else
                    {
                    //draw cursor of corresponding size

                        ostringstream charToString;
                        charToString << cherry;
                        string cherrier = charToString.str();
                        const char* cherriest=cherrier.c_str();

                        cvRectangle(frame,*cursPos,*createPoint(cursPos->x+textSize->width/2,cursPos->y+18),cvScalar(0,0,0),CV_FILLED,8,0);
                        cvPutText(frame, cherriest,*createPoint(cursPos->x,cursPos->y+textSize->height),&fondue,cvScalar(255,255,255));

                        cursPos->x+=textSize->width;
                    }
                    cvRectangle(frame,*cursPos,*createPoint(cursPos->x+textSize->width/2,cursPos->y+18),cvScalar(255,255,255),CV_FILLED,8,0);
                    cvShowImage("Tracked",frame);

                }
                ImaLabelXD:
                //move down when user hits enter
                //on 4th enter, draw textbox to the frame
                //save file



                cvSaveImage(manCount,frame);
                cvWaitKey(1000);
            }
                break;
            case 7:
                mouseEvent=0;
                for(int go=0;go<17000;go++)
                    cvSetCaptureProperty(capture,CV_CAP_PROP_POS_FRAMES,19000);
                break;
            default:
                cout<<"howdy there pardner\n";
                mouseEvent=0;
        }
        first=false;
        //Keyboard input
        /*char in;
        string help;
        getline(cin,help);
        if(help.length()>0)
        {
            in=help.at(0);

            int hi=(int)in;

            if(hi==27)
            {
                in=help.at(2);
                switch(in)
                {
                    case RIGHT:
                        for(int go=0;go<30;go++)
                            cvGrabFrame(capture);
                        break;
                    case LEFT:
                        break;
                }
            }
            else if(in==' ')
            {
                cvWaitKey(0);
            }

        }*/

        //Gets Frame from camera
        cout << "\n\nframe capture\n";
        int counter=0;
        while(frameHelp==NULL)
        {
            cout<<"oops\n";
            cvWaitKey(30);

		frameHelp = cvQueryFrame(capture);
                cvWaitKey(30);
                counter++;
                if(counter==5)
                {
                    cvReleaseCapture(&capture);
                    goto release;
                }
        }
        frameHelp = cvQueryFrame(capture);
                frame=cvCloneImage(frameHelp);
        cout << "Check\n";
        //puts the original image in the window
        //cvShowImage("Original",frame);

        cout << "declare imgGrayScale\n";
        IplImage* imgGrayScale;
        cout << "check\n";

        //Use the Pyramid thing rob has been working on here
            //
        //cvSmooth( frame, frame, CV_GAUSSIAN, 5, 5 );



        if(flag ==1){
        //Filter unwanted colors out
            cout << "HSV Flag Active\n";
            cout << "HSV Color Filter\n";
            imgGrayScale = GetThresholdedImage(frame);
            cout << "Check\n";
        }

        if(flag ==2)
        {
            cout << "Grayscale HSV Flag Active\n";
		  //Making a single channel matrix so that edge detection can work properly
            cout << "Grayscale Image\n";
		    imgGrayScale = cvCreateImage(cvGetSize(frame), 8, 1);
			     cvCvtColor(frame,imgGrayScale,CV_BGR2GRAY);
            cout << "Check\n";




		// This thresholds the grayscale image to be tested on
        cout << "Canny Threshold Image\n";
			//cvThreshold(imgGrayScale,imgGrayScale,100,255,CV_THRESH_BINARY | CV_THRESH_OTSU);
  	 		cvCanny( imgGrayScale, imgGrayScale, 50, 150, 3 );
        cout << "Check\n";
        }
        if(flag == 3)
        {
            cout << "HSV Canny Flag Active\n";
            cout << "HSV Color Filter\n";
            imgGrayScale = GetThresholdedImage(frame);
            cout << "Check\n";
            cout << "Canny Threshold Image\n";
            //cvThreshold(imgGrayScale,imgGrayScale,100,255,CV_THRESH_BINARY | CV_THRESH_OTSU);
            cvCanny( imgGrayScale, imgGrayScale, 100, 100, 3 );
            cout << "Check\n";

        }
        //cvShowImage("Helper",imgGrayScale);
        cout << "Contour Allocation\n";
  	 		CvSeq* contours;  //hold the pointer to a contour in the memory block
 			CvSeq* result;   //hold sequence of points of a contour
 			CvMemStorage *storage = cvCreateMemStorage(0); //storage area for all contours

        cout << "Check\n";

        cout << "Find Contours\n";
            //finding all contours in the image
 			cvFindContours(imgGrayScale, storage, &contours, sizeof(CvContour), CV_RETR_LIST, CV_CHAIN_APPROX_SIMPLE, cvPoint(0,0));
        cout << "Check\n";
        int timesth=254;
        CvFont fonty;
        cvInitFont(&fonty,CV_FONT_HERSHEY_SIMPLEX ,.5,.5,.5,1,8);

 			while(contours){
				//obtain a sequence of points of contour, pointed by the variable 'contour'
     			result = cvApproxPoly(contours, sizeof(CvContour), storage, CV_POLY_APPROX_DP, cvContourPerimeter(contours)*0.15, 0);
                        /*std::cout << (*result).total;
                        std::cout << "\n";
                        std::cout << (*contours).total;
                        std::cout << "\n";*/
                        int num=result->total;
                        //if two points are close enough, declare them to be the same point
                        CvPoint *pt[num];

                        for(int i=0;i<num;i++)
                        {
                            pt[i]=(CvPoint*)cvGetSeqElem(result,i);
                            /*if(i!=0&&(abs(pt[i]->x-pt[i-1]->x)<5&&abs(pt[i]->y-pt[i-1]->y)<5))
                            {
                                go=false;
                                break;
                            }*/
                        }
                        //combine points
                        int mod=0;

                        for(int i=0;i<num;i++)
                        {
                            if(pt[i]!=NULL)
                            {
                                int count=1;
                                CvPoint *tempPt = new CvPoint();
                                tempPt->x=pt[i]->x;
                                tempPt->y=pt[i]->y;
                                //ostringstream helperStrm;
                                for(int j=i+1;j<num;j++)
                                {

                                    if(pt[j]!=NULL)
                                    {


                                        if((abs(pt[i]->x-pt[j]->x)<10)&&(abs(pt[i]->y-pt[j]->y)<10))
                                        {

                                            tempPt->x+=pt[j]->x;
                                            tempPt->y+=pt[j]->y;
                                            //helperStrm<<pt[j]->x<<" ";
                                            pt[j]=NULL;
                                            mod++;
                                            count++;
                                        }
                                    }
                                }
                                if(count!=1)
                                {
                                    /*if(pt[i]->x-tempPt->x==0)
                                    {
                                        cout<< pt[i]->x<<"\n";
                                        cout<< tempPt->x<<"\n";
                                        cout<< helperStrm.str()<<"\n";
                                        cout<< count<<"\n";
                                    }*/
                                    pt[i]->x=(tempPt->x)/count;
                                    pt[i]->y=(tempPt->y)/count;

                                }
                            }
                        }
                        CvPoint *ptNew[num-mod];
                        int ayuda=0;
                        for(int i=0;i<num;i++)
                        {

                            if(pt[i]!=NULL)
                            {
                                ptNew[ayuda]=pt[i];
                                ayuda++;
                            }
                        }
                        *pt=*ptNew;



                        num-=mod;
                        //if shape has between 3 and 50 sides
                        if(num>=3 && num<=50)
                        {
                            //timesth++;

                            int colb,colr,colg = 0;
                            /*if(timesth*4<255)
                                colb=timesth*4;
                            else if(timesth*4<255*2)
                                colr=timesth*4-255;
                            else if(timesth*4<255*3)
                             colg=timesth*4-255*2;*/
                            colb=(int)(255*random());
                            colg=(int)(255*random());
                            colr=(int)(255*random());

                            //reorder points to create polygon
                            CvPoint *avg=new CvPoint();//central point of polygon
                            for(int i=0;i<num;i++)
                            {
                                avg->x+=ptNew[i]->x;
                                avg->y+=ptNew[i]->y;
                            }
                            avg->x/=num;
                            avg->y/=num;
                            //array of doubles of the angle from x-axis of each point
                            double angles[num];
                            for(int i=0;i<num;i++)
                            {
                                CvPoint *ptAdj=new CvPoint();
                                ptAdj->x=avg->x-ptNew[i]->x;
                                ptAdj->y=avg->y-ptNew[i]->y;
                                if(ptAdj->x!=0)
                                {
                                    //double mag=sqrt(ptAdj->x*ptAdj->x+ptAdj->y*ptAdj->y);
                                    angles[i]=atan(((double)(ptAdj->y))/ptAdj->x);//check for case where ptAdj->x=0
                                    if(ptAdj->x<0)
                                        angles[i]=M_PI+angles[i];
                                    if(angles[i]<0||angles[i]>2*M_PI)
                                        angles[i]+= (angles[i]<0)?2*M_PI:-2*M_PI;

                                }
                                else
                                {
                                    angles[i]= (ptAdj->y>0)?M_PI/2:3*M_PI/2;
                                }
                            }

                            //sort both at the same time based upon the array of doubles, smallest to largest]
                            for(int i=0;i<num;i++)
                            {
                                double smallest=50000.0;
                                int loc=i;
                                for(int j=i;j<num;j++)
                                {
                                    if(angles[j]<smallest)
                                    {
                                        smallest=angles[j];
                                        loc=j;
                                    }

                                }
                                int xt=ptNew[i]->x;
                                int yt=ptNew[i]->y;
                                double at=angles[i];
                                ptNew[i]->x=ptNew[loc]->x;
                                ptNew[i]->y=ptNew[loc]->y;
                                angles[i]=angles[loc];
                                ptNew[loc]->x=xt;
                                ptNew[loc]->y=yt;
                                angles[loc]=at;
                            }


                            //determine shape
                            double interiors[num];
                            for(int i=0;i<num;i++)
                            {
                                interiors[i]=acos(angle(ptNew[i],ptNew[(i+1)%num],ptNew[(i+2)%num]));
                            }
                            bool good=true;

                            //cout<<M_PI/num<<"\t"<<M_PI/num*.1<<"\n";
                            for(int i=0;i<num;i++)
                            {
                                //cout<<interiors[i]<<"\n";
                                if(interiors[i]<M_PI/num-M_PI*.2/num||interiors[i]>M_PI/num+M_PI*.2/num)
                                {
                                    good=false;

                                }
                            }
                            //cout<<"\n\n\n";
                            if(good||true)
                            {
                                //cout<<"checker4\n\n\n";

                                //draw shapes
                                for(int i=0;i<num;i++)
                                {

                                    string text;
                                    ostringstream convert;
                                    convert<<interiors[i];
                                    text=convert.str();
                                    convert.flush();
                                    convert.clear();
                                    const char* texty=text.c_str();
                                    //cout << text

                                    if(i==num-1)
                                    {
                                        cvLine(frame,*ptNew[i],*ptNew[0],cvScalar(colb,colg,colr),2);

                                    }
                                    else
                                        cvLine(frame,*ptNew[i],*ptNew[i+1],cvScalar(colb,colg,colr),2);

                                   // cvPutText(frame, texty,*ptNew[i],&fonty,cvScalar(colg,colr,colb));
                                }
                            }

                        }
       			//Triangle Detection
       			 //if there are 3  vertices  in the contour(It should be a triangle)
    			/*if(result->total==3 )
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

            					//cout << "\nsquare\n" ;
            					//cout << firstAngle; //Uncomment this to get the angles that its detecting.
            				}
        			}
     			}*/
                contours = contours->h_next;


 			}



		  //Put the images in the frame
 		cvShowImage("Tracked",frame);
                //cvShowImage("Thresholded",imgGrayScale);


 			char c = cvWaitKey(33);

 		if(c==27)
   		 {
        	//cleaning up
        	cvDestroyAllWindows();
        	cvReleaseImage(&frame);
        	cvReleaseImage(&imgGrayScale);
        	cvReleaseMemStorage(&storage);
                cvReleaseCapture(&capture);
    			break;
   		 }

   		 //for(int i=1;i<100000000/5;i++);
   		 cvReleaseImage(&imgGrayScale);
         cvReleaseMemStorage(&storage);
         //std::cin.ignore();
	}

    return 0;


}

IplImage* GetThresholdedImage(IplImage* imgHSV){
    IplImage* imgThresh=cvCreateImage(cvGetSize(imgHSV),IPL_DEPTH_8U,1);
    cvInRangeS(imgHSV, cvScalar(Hue_Min,Saturation_Min,Value_Min), cvScalar(Hue_Max,Saturation_Max,Value_Max), imgThresh);
    return imgThresh;

}
void onMouse(int event, int x, int y, int, void*)
{
    mouseEvent=1;
    if(event==EVENT_LBUTTONDOWN)
    {
        mousePos->x=x;
        mouseEvent=6;
    }
    else if(event==EVENT_RBUTTONDOWN)
    {
        mousePos->y=y;
        mouseEvent=7;
    }


}

double angle( CvPoint* pt1, CvPoint* pt2, CvPoint* pt0 )
{
    double dx1 = pt1->x - pt0->x;
    double dy1 = pt1->y - pt0->y;
    double dx2 = pt2->x - pt0->x;
    double dy2 = pt2->y - pt0->y;
    return (dx1*dx2 + dy1*dy2)/sqrt((dx1*dx1 + dy1*dy1)*(dx2*dx2 + dy2*dy2) + 1e-10);
}
CvPoint* createPoint(int xc, int yc)
{
    CvPoint* fuckme=new CvPoint();
    fuckme->x=xc;
    fuckme->y=yc;
    return fuckme;
}
vector<string> &split(const string &s, char delim, vector<string> &elems)
{
    stringstream ss(s);
    string item;
    while (getline(ss, item, delim))
    {
        elems.push_back(item);
    }
    return elems;
}


vector<string> split(const std::string &s, char delim)
{
    std::vector<std::string> elems;
    split(s, delim, elems);
    return elems;
}
