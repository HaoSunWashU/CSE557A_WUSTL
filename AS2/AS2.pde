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
float maxNum = 0.0;                 //store the max population
float maxNumOfBar = 0.0;
float dataSum = 0.0;                //store the sum of date num
boolean[] whichBarIsSelected;               //indicate which data is selected
String chartTitle;       //title of chart

//position informaiton for bar chart
float[] heights;
float barWidth;
float[] xPos;
float[] yPos;

//position information for line chart

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
// 1. 52,109,241
// 2. 226, 44, 41
// 3. 45, 156, 65
// selected 249,176,12

//Colors of pie

//Current chart statement
boolean bar = true;                  
boolean line = false;

//Chart transition statement
int currentState = 0;                //current chart mode 0 : bar chart; 1 : line chart; 2: pie chart
int whichButton = 0;                 //indicate which button the mouse is on. 0 for nothing, 1,2,3 for three buttons
boolean barToLine = false;           //The following variables are used to judge chart transition action
boolean barToPie = false;
boolean lineToBar = false;
boolean lineToPie = false;
boolean pieToBar = false;
boolean pieToLine = false;
  
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
}

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
  
  //if current chart mode is bar chart or line chart, draw the following text
  if(currentState!=2){
    pushMatrix(); //push current transformation setting into matrix for later use
    //modify transform
    translate(0.025* width, 0.5 * height);
    rotate(3 * PI / 2);
    textFont(fontInfo, 20 * textPercentage);
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
  //There are 9 situations: 1. bar chart; 2. bar to line; 3. bar to pie;
  //                        4. line chart; 5. line to bar; 6. line to pie;
  //                        7. pie chart; 8. pie to bar; 9. pie to line;
  //among those situations, there are 4 special one 1. 2. 4. 5.
  //because 1. 2. 4. 5. must have labels and horizontal lines for indication
  
  if(barToPie){
  
  }
  
  if(pieToBar){
  
  }
  
  if(lineToPie){
  
  }
  
  if(pieToLine){
  
  }
  
  //situations 1. 2. 4. 5. draw labels for x-axis and y-axis
  if(currentState!=2 && !barToPie && !lineToPie){
    
  }
}

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
    if(num>maxNum){
      maxNum = num;
    }
  }
  //debug
  println("num of rows: " + count);
  println("title: " + titles[0] + ", " + titles[1]);
  println("First row of data: " + dataNames[0] + ", " + dataNums[0]);
  println("The max num is: " + maxNum);
  println("The sum is: " + dataSum);
}

void updatePositionInformationForBar(){
  heights = new float[count];
  xPos = new float[count];
  yPos = new float[count];
  directions = new float[count];
  barWidth = ((5.0/6.0)*width)/(2.0 * count + 1); //width of each bar
  for(int i = 0; i < count; i++){
    //ratioToMaxNum is designed to adjust the height of each bar
    float ratioToMaxNum = dataNums[i] / maxNum;
    heights[i] = 0.8 * heightSize * ratioToMaxNum; //80% zoom: the max one 
    //(xCenter - widthSize/2) is the left margin
    xPos[i] = (xCenter - widthSize/2) + barWidth + (2 * i * barWidth);
    yPos[i] = (yCenter - heightSize/2) + heightSize - heights[i];
    directions[i] = 360.0 * dataNums[i] / dataSum; //computer direction angle for pie chart
  }
  maxNumOfBar = maxNum / 0.8; 
}

//detect mouse position
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
    case 1: 
      
      break;
    case 2: 
      
      break;
    case 3: 
      
      break;
    }
  }
}

//drawLabels for bar chart and line chart and transition of line-to-bar and bar-to-line 
void drawLabels(){
  
}

//draw a bar and detect whether the mouse is on this bar, use whichBarIsSelected[] to record
void drawBar(float xPos, float yPos, float barHeight){ //52,109,241 blue 249, 176, 12 yellow
  //mouse on this bar
  if(mouseX > xPos && mouseX < xPos + barWidth &&
  mouseY > yPos && mouseY < yPos + barHeight){
    stroke(249,176,12);  //selection rect
    strokeWeight(4);
    fill(249,176,12);
    rectMode(CORNER);
    rect(xPos, yPos, barWidth, barHeight);
  }
  else{
    rectMode(CORNER);
    rect(xPos, yPos, barWidth, barHeight);
  }
}