//Canvas intformation for chart
int xCenter;
int yCenter;
int widthSize;
int heightSize;
PFont fontInfo;

//Data information
Table dataTable;                    //create a table to load data from .csv
String fileName = "data_1.csv";     //fileName stores the name of data source
int count;                          //store the num of data
String[] dataNames;                 //name of first column
float[] dataNums;                   //populations of different distributions
String[] titles;                    //titles of first row in .csv
float maxNum = 0.0;                 //store the max population
float dataSum = 0.0;                //store the sum of date num
boolean[] isSelected;               //indicate which data is selected
String chartTitle = "Population distributions";       //title of chart

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
int x_1 = 700;
int y_1 = 50;
int x_2 = 870;
int y_2 = 50;
int x_3 = 1040;
int y_3 = 50;

//button size
int width_button = 120;
int height_button = 50;

//button selection rect size
int width_selection = 130;
int height_selection = 60;

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
int currentChartMode = 0;            //current chart mode 0 : bar chart; 1 : line chart; 2: pie chart
int whichButton = 0;                 //indicate which button the mouse is on. 0 for nothing, 1,2,3 for three buttons
boolean barToLine = false;           //The following variables are used to judge chart transition action
boolean barToPie = false;
boolean lineToBar = false;
boolean lineToPie = false;
boolean pieToBar = false;
boolean pieToLine = false;
  
//initialize canvas
void setup(){
  size(1200,800);
  //size of center canvas for chart display
  xCenter = 600;
  yCenter = 400;
  widthSize = 1000;
  heightSize = 600;
  smooth();
  surface.setResizable(true);
  background(120);
  
  //Load data from .csv file and store the data into dataNames and dataNums
  loadData();                      
  updatePositionInformationForBar(); //update position information for Bar Chart
  chartTitle = "Population distribution";
  fontInfo = createFont("Georgia", 16, true);
}

void draw(){
  //refresh the canvas
  //clear();
  //background(120);
  surface.setResizable(true);
  rectMode(CENTER);
  fill(230);
  rect(xCenter, yCenter, widthSize, heightSize, 1);
  textFont(fontInfo, 38);
  fill(250);
  textAlign(CENTER);
  text(chartTitle, 300, 50);
  
  //if current chart mode is bar chart or line chart, draw the following text
  if(currentChartMode!=2){
    pushMatrix(); //push current transformation setting into matrix for later use
    //modify transform
    translate(0.05* width, 0.5 * height);
    rotate(3 * PI / 2);
    textFont(fontInfo, 20);
    text(titles[1], 0, 0);
    popMatrix();  //pop former transform
    text(titles[0], 0.5*width, 0.95*height);
  }
  
  //draw three buttons : 1. Bar Chart; 2. Line Chart; 3. Pie Chart.
  mouseOnWhichButton(); //detect mouse position, if mouse is hovering over button change color
  //draw selection rect for buttons based on current chart mode
  stroke(249,176,12);  //selection rect
  strokeWeight(8);
  fill(249,176,12);
  switch(currentChartMode){
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
  text("Bar chart", x_1, y_1+8);
  text("Line chart", x_2, y_2+8);
  text("Pie chart", x_3, y_3+8);
  //toggleAnimationPhase();
  
  
  //debug
  //println(whichButton);
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
  barWidth = widthSize/(2.0 * count + 1);
  for(int i = 0; i < count; i++){
    //ratioToMaxNum is designed to adjust the height of each bar
    float ratioToMaxNum = dataNums[i] / maxNum;
    heights[i] = 0.8 * heightSize * ratioToMaxNum; //80% zoom
    //(xCenter - widthSize/2) is the left margin
    xPos[i] = (xCenter - widthSize/2) + barWidth + (2 * i * barWidth);
    yPos[i] = (yCenter - heightSize/2) + heightSize - heights[i];
    directions[i] = 360.0 * dataNums[i] / dataSum; //computer direction angle for pie chart
  }
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

//drawLabels for bar chart and line chart
void drawLabels(){
  
}

void drawBar(float xPos, float yPos, float barHeight){
}