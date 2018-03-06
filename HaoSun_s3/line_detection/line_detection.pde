int numPoints = 20;
Point[] shape;
Point endP;

void setup() {
    size(400, 400);
    smooth();
    shape = new Point[numPoints];
    endP = new Point();

    makeRandomShape();

    surface.setResizable(true);
}

void draw() {
    background(255, 255, 255);
    stroke(0, 0, 0);

    drawShape();
    if (mousePressed == true) {
        stroke(255, 0, 0);
        line(mouseX, mouseY, endP.x, endP.y);

        fill(0, 0, 0);
        boolean isect = isectTest();
        if (isect == true) {
            text("Inside", mouseX, mouseY);
        } else {
            text("Outside", mouseX, mouseY);
        }
    }
}

void mousePressed() {
    endP.x = random(-1, 1) * 2 * width;
    endP.y = random(-1, 1) * 2 * height;
}

void drawShape() {
    for (int i = 0; i < numPoints; i++) {
        int start = i;
        int end = (i + 1) % numPoints;

        line(shape[start].x + width/2.0f, 
             shape[start].y + height/2.0f,
             shape[end].x + width/2.0f, 
             shape[end].y + height/2.0f);
    }
}

boolean isectTest() {
  int intersectNum=0;
  float mx = mouseX;
  float my = mouseY;
  float endX = endP.x;
  float endY = endP.y;
  
  for(int i = 0; i < numPoints; i++){ //iterate points of shape  //  0 ---- (numPoints)
     Point startPoint = new Point();
     startPoint.x = shape[i].x + width/2.0f;
     startPoint.y = shape[i].y + height/2.0f;
     
     Point endPoint = new Point();
     endPoint.x = shape[(i+1)%numPoints].x + width/2.0f;
     endPoint.y = shape[(i+1)%numPoints].y + height/2.0f;
     
     float a1, b1, a2, b2;
     a1 = (float)(startPoint.y - endPoint.y)/(startPoint.x - endPoint.x);
     b1 = startPoint.y - a1*startPoint.x;
     
     //endP.x endP.y
     a2 = (float)(my - endY)/(mx - endX);
     b2 = my - a2*mx;
     
     if(a1 == a2){  //horizontal, continue
       println("continue");
       continue;
      
     }else{
       // calculate intersection point
       Point interPoint = new Point();
       interPoint.x = (b2 - b1) / (a1 - a2);
       interPoint.y = a1 * interPoint.x + b1;
       
       if(isBetween(interPoint.x, startPoint.x, endPoint.x) &&
          isBetween(interPoint.y, startPoint.y, endPoint.y) && 
          isBetween(interPoint.x, mx, endX)&&
          isBetween(interPoint.y, my, endY)){
          intersectNum++;
       }
     }
  }
  println("intersectNum = " + intersectNum);
  if(intersectNum % 2 == 0){
    return false;
  }
  else{
    return true;
  }
}

boolean isBetween(float val, float range1, float range2) {
    float largeNum = range1;
    float smallNum = range2;
    if (smallNum > largeNum) {
        largeNum = range2;
        smallNum = range1;
    }

    if ((val < largeNum) && (val > smallNum)) {
        return true;
    }
    return false;
}

void makeRandomShape() {
    float slice = 360.0 / (float) numPoints;
    for (int i = 0; i < numPoints; i++) {
        float radius = (float) random(5, 100);
        shape[i] = new Point();
        shape[i].x = radius * cos(radians(slice * i));
        shape[i].y = radius * sin(radians(slice * i));
    }
}