import cv2
import numpy as np
import math
def getSlope(listthreed):
    slope =[]
    for i in range(0,4) :
        x1 = listthreed[i][0][0]
        y1 = listthreed[i][0][1]
        x2 = listthreed[(i+1)%len(listthreed)][0][0]
        y2 = listthreed[(i+1)%len(listthreed)][0][1]
        if (x2-x1 != 0):
            tempslope = (y2-y1)/(x2-x1)
        else:
            tempslope = 0
        print("slope", tempslope)
        slope.append(int(tempslope))
    return slope

def processImage(imgurl):
    img = cv2.pyrDown(cv2.imread(imgurl, cv2.IMREAD_UNCHANGED))
    ret, thresh = cv2.threshold(cv2.cvtColor(img.copy(), cv2.COLOR_BGR2GRAY) , 175, 255, cv2.THRESH_BINARY)

    # cv2.imshow("contours", thresh)
    # cv2.waitKey()
    edges = cv2.Canny(thresh,150,200,apertureSize = 3)
    # cv2.imshow("contours", edges)
    # cv2.waitKey()
    contours, hier = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    for c in contours:
        # find bounding box coordinates
        #x,y,w,h = cv2.boundingRect(c)
        #cv2.rectangle(img, (x,y), (x+w, y+h), (0, 255, 0), 2)

        # find minimum area
        #rect = cv2.minAreaRect(c)
        # calculate coordinates of the minimum area rectangle
        #box = cv2.boxPoints(rect)
        # normalize coordinates to integers
        #box = np.int0(box)
        # draw contours
        #cv2.drawContours(img, [box], 0, (0,0, 255), 3)
        # calculate center and radius of minimum enclosing circle
        #(x,y),radius = cv2.minEnclosingCircle(c)
        # cast to integers
        #center = (int(x),int(y))
        #radius = int(radius)
        # draw the circle
        #img = cv2.circle(img,center,radius,(0,255,0),2)
        epsilon = 0.01 * cv2.arcLength(c, True)
        approx = cv2.approxPolyDP(c, epsilon, True)

        # hull = cv2.convexHull(c)
    # print(hull)
    sisi = []
    if len(approx)>=3 and len(approx)<=6 :
        for i in range(0,len(approx)) :
            x1 = approx[i][0][0]
            y1 = approx[i][0][1]
            x2 = approx[(i+1)%len(approx)][0][0]
            y2 = approx[(i+1)%len(approx)][0][1]
            dist = math.sqrt((x1-x2)**2 + (y1-y2)**2)
            sisi.append(int(dist))

        print("SISI",sisi)
        if len(approx) ==4:
            return sisi,getSlope(approx)
        else :
            return sisi,[]
    else :
        return -9999,-9999

    #cv2.drawContours(img, hull, -1, (0, 0, 255), 1)
    #cv2.drawContours(img, approx, -1, (0, 255, 0), 1)
    #cv2.drawContours(img, contours, -1, (255, 0, 0), 1)
    #cv2.imshow("contours", img)
    #cv2.waitKey()

#print(processImage("triangle.jpg"))