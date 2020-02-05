import cv2
import numpy as np


img = cv2.imread('dave.jpg')
kernel = np.ones((5, 5), np.float32) / 25    
smoothed = cv2.filter2D(img, -1, kernel)
gray = cv2.cvtColor(smoothed,cv2.COLOR_BGR2GRAY)
edges = cv2.Canny(gray,50,200,apertureSize = 3)

lines = cv2.HoughLines(edges,0.1,np.pi/180,20)
print(lines)
for line in lines:
    rho,theta = line[0]
    a = np.cos(theta)
    b = np.sin(theta)
    x0 = a*rho
    y0 = b*rho
    x1 = int(x0 + 1000*(-b))
    y1 = int(y0 + 1000*(a))
    x2 = int(x0 - 1000*(-b))
    y2 = int(y0 - 1000*(a))

    cv2.line(img,(x1,y1),(x2,y2),(0,0,255),2)
    # x1, y1, x2, y2 = line[0]
    # cv2.line(img, (x1, y1), (x2, y2), (255, 0, 0), 3)

cv2.imwrite('houghlines5.jpg',img)
cv2.imwrite('houghlinesgray.jpg',gray)
cv2.imwrite('houghlinesedge.jpg',edges)