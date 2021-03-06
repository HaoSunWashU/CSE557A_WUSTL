//Canvas intformation for chart
//int canvasX = 1200;
//int canvasY = 800;
float xCenter;
float yCenter;
float widthSize;
float heightSize;
PFont fontInfo;

//Data information
Table dataTable;                    //create a table to load data from .csv
String fileName = "data_1.csv";     //fileName stores the name of data source
int count;                          //store the num of data
String[] dataNames;                 //name of first column
float[] dataNums;                   //populations of different distributions
String[] titles;                    //titles of first row in .csv
float maxValue = 0.0;                 //store the max value
float maxValueOfBar = 0.0;
float dataSum = 0.0;                //store the sum of date num
boolean[] isSelected;               //indicate which data is selected
String chartTitle;       //title of chart

//position informaiton for bar chart
float[] heights;
float barWidth;
float[] xPos;
float[] yPos;

//position information for line chart
float xPosPrePoint = 0.0; //store the previous point of current point, in order to connect a line
float yPosPrePoint = 0.0;

//position information for pie chart
float[] directions;                  //direction angle for each part
float[] xPosPie;
float[] yPosPie;

//position information for three transition buttons
float x_1;
float y_1;
float x_2;
float y_2;
float x_3;
float y_3;

//button size
float width_button;
float height_button;

//button selection rect size
float width_selection;
float height_selection;

//button color and selection rect color
// 1. 52,109,241     blue
// 2. 226, 44, 41    red
// 3. 45, 156, 65    green
// selected 249,176,12

//Colors of pie

//Current chart statement
boolean bar = true;                  
boolean line = false;

//Chart transition statement
int currentState = 0;                //current chart mode 0 : bar chart; 1 : line chart; 2: pie chart
int whichButton = 0;                 //indicate which button the mouse is on. 0 for nothing, 1,2,3 for three buttons
int ticks = 0;                       //control the process of transition

boolean barToLine = false;           //The following variables are used to judge chart transition action
boolean barToPie = false;
boolean lineToBar = false;
boolean lineToPie = false;
boolean pieToBar = false;
boolean pieToLine = false;          //only one will be true or all will be false
  
//initialize canvas
void setup(){
  size(1200, 800);
  smooth();
  surface.setResizable(true);
  background(120);
  
  //Load data from .csv file and store the data into dataNames and dataNums
  loadData();                      
  chartTitle = "Hao's Chart: " + titles[0] + " measured by " + titles[1];
  fontInfo = createFont("Georgia", 16, true);
  isSelected = new boolean[count];
  for(int i = 0; i < count; i++){
    isSelected[i] = false;
  }
}

//&&&&& main drawing funtion &&&&&&//
void draw(){
  //refresh the canvas
  clear();
  background(120);
  surface.setResizable(true);
  rectMode(CENTER);
  fill(230);
  xCenter = width/2;
  yCenter = height/2;
  widthSize = width-(width/6);
  heightSize = height-(height/4);
  rect(xCenter, yCenter, widthSize, heightSize, 1);
 
  //calculate font percent in this canvas
  float textPercentage = (width/1200.0 + height/800.0)/2.0;
  float textSize = 24 * textPercentage;
  textFont(fontInfo, textSize);
  fill(250);
  textAlign(CENTER);
  text(chartTitle, 0.3*width, 0.05*height);
  textFont(fontInfo, 20 * textPercentage);
  //if current chart mode is bar chart or line chart, draw the following text
  if(currentState!=2){
    pushMatrix(); //push current transformation setting into matrix for later use
    //modify transform
    translate(0.018* width, 0.5 * height);
    rotate(3 * PI / 2);
    //textFont(fontInfo, 20 * textPercentage);
    text(titles[1], 0, 0);
    popMatrix();  //pop former transform
    text(titles[0], 0.5*width, 0.975*height);
  }
  
  //calculate the position and size of three buttons
  //position information for three transition buttons
  x_1 = (760.0/1200.0) * width;
  y_1 = 0.0625 * height;
  x_2 = (900.0/1200.0) * width;
  y_2 = 0.0625 * height;
  x_3 = (1040.0/1200.0) * width;
  y_3 = 0.0625 * height;

  //button size
  width_button = width / 10;
  height_button = 0.0625 * height;

  //button selection rect size
  width_selection = width/10 + (10/1200) * width;
  height_selection = 0.0625 * height + (10/800) * height;
  
  //draw three buttons : 1. Bar Chart; 2. Line Chart; 3. Pie Chart.
  mouseOnWhichButton(); //detect mouse position, if mouse is hovering over button change color
  //draw selection rect for buttons based on current chart mode
  stroke(249,176,12);  //selection rect
  strokeWeight(10.0/1200.0 * width);
  fill(249,176,12);
  switch(currentState){
    case 0:
      rect(x_1, y_1, width_selection, height_selection, 8);
      break;
    case 1:
      rect(x_2, y_2, width_selection, height_selection, 8);
      break;
    case 2:
      rect(x_3, y_3, width_selection, height_selection, 8);
      break;
  }
  stroke(20);
  strokeWeight(2);
  
  switch(whichButton){
    case 0: //mouse is not hovering over any button, just check chart mode to determine the color of button
      fill(52,109,241);//first button
      rect(x_1, y_1, width_button, height_button, 8);
      fill(226,44,41);
      rect(x_2, y_2, width_button, height_button, 8);
      fill(45,156,65);
      rect(x_3, y_3, width_button, height_button, 8);
      break;
    case 1:
      fill(180);
      rect(x_1, y_1, width_button, height_button, 8);
      fill(226,44,41);
      rect(x_2, y_2, width_button, height_button, 8);
      fill(45,156,65);
      rect(x_3, y_3, width_button, height_button, 8);
      break;
    case 2:
      fill(52,109,241);//first button
      rect(x_1, y_1, width_button, height_button, 8);
      fill(180);
      rect(x_2, y_2, width_button, height_button, 8);
      fill(45,156,65);
      rect(x_3, y_3, width_button, height_button, 8);
      break;
    case 3:
      fill(52,109,241);//first button
      rect(x_1, y_1, width_button, height_button, 8);
      fill(226,44,41);
      rect(x_2, y_2, width_button, height_button, 8);
      fill(180);
      rect(x_3, y_3, width_button, height_button, 8);
      break;
    
  }
  //draw text on buttons
  fill(240);
  text("Bar chart", x_1, y_1 + 0.01*height);
  text("Line chart", x_2, y_2 + 0.01*height );
  text("Pie chart", x_3, y_3 + 0.01*height);
  
  //transitionControl();
  
  //debug
  //println(whichButton);
  
  updatePositionInformationForBar(); //update position information for Bar Chart
  //The following is the main part of this draw() function: draw bar chart, line chart and pie chart
  //There are 9 situations: (1) 1. bar chart; 2. line to bar; 3. pie to bar;
  //                        (2) 4. line chart; 5. bar to line; 6. pie to line;
  //                        (3) 7. pie chart; 8. bar to pie; 9. line to pie;
  //among those situations, there are 4 special one 1. 2. 4. 5.
  //because 1. 2. 4. 5. must have labels and horizontal lines for indication
  //situations 1. 2. 4. 5. draw labels for x-axis and y-axis
  if((currentState==0 || currentState==1) && !barToPie && !lineToPie){
    //draw labels
    drawLabels_Y();
    drawLabels_X();
  }
  
  switch(currentState){
    case 0:  //(1) 1. bar chart; 2. line to bar; 3. pie to bar;
      if(!lineToBar && !pieToBar){  //static situation of Bar Chart
        //draw Bar
        for(int i = 0; i < count; i++){
          drawBar(xPos[i], yPos[i], barWidth, heights[i], i);
        }
        //When mouse hovering over a bar, display the information of that bar
        for (int i = 0; i < count; i++) {
          if (isSelected[i] == true) {
            fill(0);
            textFont(fontInfo, 20 * textPercentage);
            text(dataNames[i] + " : " + dataNums[i], mouseX, mouseY);
          }
        }
      }else if(lineToBar){ //transition from Line chart to Bar chart
      
      }else if(pieToBar){ //transition from Pie chart to Bar chart
      
      }else{}
      break;
    case 1:  //(2) 4. line chart; 5. bar to line; 6. pie to line;
      if(!barToLine && !pieToLine){ //draw static Line
        for(int i = 0; i < count; i++){
          drawLine(xPos[i], yPos[i], i);
        }
        
        for(int i = 0; i < count; i++){
          if(isSelected[i] == true){
            fill(0);
            textFont(fontInfo, 20 * textPercentage);
            text(dataNames[i] + " : " + dataNums[i], mouseX, mouseY); 
          }
        }
        
      }else if(barToLine){ //transition from Bar chart to Line chart
        
        
      }else if(pieToLine){ //transition from Pie chart to Line chart
        
      
      }else{}
      break;
    case 2:  //(3) 7. pie chart; 8. bar to pie; 9. line to pie;
      if(!barToPie && !lineToPie){ //draw Pie chart
      
      
      }else if(barToPie){
      
      }else if(lineToPie){
      
      }else{}
      break;
  }
}


//***** Load data from .csv *****//
void loadData(){
  //load first row of the data.csv
  String[] data = loadStrings(fileName);
  titles = split(data[0], ",");
  //load data from CSV file into a Table Object
  // "header" option indicates the file has a header row
  dataTable = loadTable(fileName,"header");
  count = dataTable.getRowCount();
  dataNames = new String[count];
  dataNums = new float[count];
  
  //iterate over all the rows in a table
  int rowCount = 0;
  for(TableRow row : dataTable.rows()){
    //you can access the fields via their column name (or index)
    String name = row.getString(titles[0]);
    int num = row.getInt(titles[1]);
    dataNames[rowCount] = name;
    dataNums[rowCount] = num;
    rowCount++;
    dataSum += num;
    if(num>maxValue){
      maxValue = num;
    }
  }
  //debug
  println("num of rows: " + count);
  println("title: " + titles[0] + ", " + titles[1]);
  println("First row of data: " + dataNames[0] + ", " + dataNums[0]);
  println("The max num is: " + maxValue);
  println("The sum is: " + dataSum);
}

//***** update Position information based data loaded from .csv ******//
void updatePositionInformationForBar(){
  heights = new float[count];
  xPos = new float[count];
  yPos = new float[count];
  directions = new float[count];
  barWidth = ((5.0/6.0)*width)/(2.0 * count + 1); //width of each bar
  for(int i = 0; i < count; i++){
    //ratioToMaxNum is designed to adjust the height of each bar
    float ratioToMaxNum = dataNums[i] / maxValue;
    heights[i] = 0.8 * heightSize * ratioToMaxNum; //80% zoom: the max one 
    //(xCenter - widthSize/2) is the left margin
    xPos[i] = (xCenter - widthSize/2) + barWidth + (2 * i * barWidth);
    yPos[i] = (yCenter - heightSize/2) + heightSize - heights[i];
    directions[i] = 360.0 * dataNums[i] / dataSum; //computer direction angle for pie chart
  }
  maxValueOfBar = maxValue / 0.8; 
}

//^^^^^ transition control ^^^^^//  180 ticks for drawing transition
void ticksHandle(){
  if(barToLine || barToPie || lineToBar || lineToPie || pieToBar || pieToLine){
    ticks++;
    if(ticks >= 180){ //transition finish, all false and ticks back to 0
      barToLine = false;
      barToPie = false;
      lineToBar = false;
      lineToPie = false;
      pieToBar = false;
      pieToLine = false; 
    }
  }
}


//&&&&&  Mouse detection &&&&&//
void mouseOnWhichButton(){
  whichButton = 0;
  if(mouseX > (x_1 - width_button/2) && mouseX < (x_1 + width_button/2)
  && mouseY > (y_1 - height_button/2) && mouseY < (y_1 + height_button/2)){
    whichButton = 1;
  }
  
  if(mouseX > (x_2 - width_button/2) && mouseX < (x_2 + width_button/2)
  && mouseY > (y_2 - height_button/2) && mouseY < (y_2 + height_button/2)){
    whichButton = 2;
  }
  
  if(mouseX > (x_3 - width_button/2) && mouseX < (x_3 + width_button/2)
  && mouseY > (y_3 - height_button/2) && mouseY < (y_3 + height_button/2)){
    whichButton = 3;
  }
}

void mousePressed(){
  mouseOnWhichButton();
  //Only without transition, program can change the situation.
  if(!barToLine && !barToPie && !lineToBar && !lineToPie && !pieToBar && !pieToLine){
    switch(whichButton){
    case 0: break;
    case 1:   //Bar chart button
      //if (currentState == 1) {
      //  lineToBar = true;
      //}
      //if (currentState == 2) {
      //  pieToBar = true;
      //}
      currentState = 0;
      break;
    case 2:   //Line chart button
      //if (currentState == 0) {
      //  barToLine = true;
      //}
      //if (currentState == 2) {
      //  pieToLine = true;
      //}
      currentState = 1;
      break;
    case 3:   //Pie chart button
      //if (currentState == 0) {
      //  barToPie = true;
      //}
      //if (currentState == 1) {
      //  lineToPie = true;
      //}
      currentState = 2;
      break;
    }
    println(currentState);
  }
}

//********** drawing functions *********//

//drawLabels for bar chart and line chart and transition of line-to-bar and bar-to-line 
void drawLabels_Y(){
  //draw five values on Y axis
  for(int i = 0; i < 5; i++){
    float value = (i/4.0) * maxValueOfBar;
    float xPos_value = 0.055 * width;
    float yPos_value = (yCenter - heightSize/2) + (4-i)/4.0 * heightSize;
    float textPercentage = (width/1200.0 + height/800.0)/2.0;
    float textSize = 12 * textPercentage;
    textFont(fontInfo, textSize);
    text(value, xPos_value, yPos_value);
    stroke(160);
    line(xCenter - widthSize/2.0, yPos_value, xCenter + widthSize/2.0, yPos_value);
    stroke(0);
  }
  //for(int i = 0; i < 3; i++){
  //  //line(0.1*width, yPos, (0.1*width + (0.75*width)), yPos);
  //}
}

void drawLabels_X(){
  for(int i = 0; i < count; i++){
    //Draw labels on x axis
    float textPercentage = (width/1200.0 + height/800.0)/2.0;
    float textSize = 10 * textPercentage;
    textFont(fontInfo, textSize);
    fill(250);
    pushMatrix();
    translate(xPos[i], 0.92* height);
    rotate(7.0*PI/4.0);
    text(dataNames[i], 0.0, 0.0);
    popMatrix();
  }
}

//draw a Bar and detect whether the mouse is on this bar, use isSelected[] to record
void drawBar(float xPos, float yPos, float barWidth, float barHeight, int i){ //52,109,241 blue 249, 176, 12 yellow
  //mouse on this bar
  if(mouseX > xPos && mouseX < xPos + barWidth && mouseY > yPos && mouseY < yPos + barHeight){
    stroke(249,176,12);  //selection rect
    strokeWeight(4);
    fill(249,176,12);
    rectMode(CORNER);
    rect(xPos, yPos, barWidth, barHeight, 2);
    isSelected[i] = true;
    stroke(0);
    strokeWeight(2);
  }
  else{
    rectMode(CORNER);
    fill(52,109,241);
    stroke(220);
    strokeWeight(2);
    rect(xPos, yPos, barWidth, barHeight, 2);
    isSelected[i] = false;
    stroke(0);
  }
}

//draw a Line graph and detect whether the mouse is on the Point, use  isSelected[] to record
void drawLine(float xPos, float yPos, int i){    //2. 226, 44, 41    red
  float percentage = width/1200.0; //calculate the scale percentage for point radius
  float pointRadius = 14.0 * percentage;
  
  //mouse hover over the point
  if(pow((mouseX - xPos),2) + pow((mouseY - yPos),2) < pow(pointRadius,2)){
    stroke(249,176,12);  //selection rect
    strokeWeight(18);
    fill(249,176,12);
    ellipse(xPos, yPos, pointRadius, pointRadius);
    isSelected[i] = true;
    stroke(0);
    strokeWeight(2);
  }else{
    stroke(226,44,41);
    fill(226,44,41);
    ellipse(xPos, yPos, pointRadius, pointRadius);
    isSelected[i] = false;
    stroke(0);
  }
  
  if(i > 0){ //draw a line from previous point from second point
    stroke(226,44,41);
    line(xPosPrePoint, yPosPrePoint, xPos, yPos);
    stroke(0);
  }
  
  xPosPrePoint = xPos;
  yPosPrePoint = yPos;
}

void drawPie(){

}

//%%%%%  transition   %%%%%//
void transition_Bar_to_Line(){  //there are 3 steps: 1. Bar to Line; 2. Line to Point; 3. Connect the Points
//Color is also changing, from // (52,109,241) blue to  (226, 44, 41) red

}

void transition_Line_to_Bar(){

}

void transition_Bar_to_Pie(){

}

void transition_Pie_to_Bar(){

}

void transition_Line_to_Pie(){

}

void transition_Pie_to_Line(){

}